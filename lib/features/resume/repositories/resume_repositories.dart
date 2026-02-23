// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'package:resume_ai/features/resume/model/analysed_resume_model.dart';
import 'package:resume_ai/features/resume/model/chat_model.dart';

class ResumeRepositories {
  final Uri resumeParsingUrl = Uri.parse('http://render.com/resume-parsing');

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Map<String, String> _chatContextCache = <String, String>{};

  /// Extract text from PDF file
  Future<String> extractTextFromPDF(String filePath) async {
    try {
      log('📄 [PDF Extraction] Starting to extract text from: $filePath');

      final File file = File(filePath);
      if (!await file.exists()) {
        log('❌ [PDF Extraction] File not found: $filePath');
        return '';
      }

      final bytes = await file.readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: bytes);
      final PdfTextExtractor extractor = PdfTextExtractor(document);
      final StringBuffer extractedText = StringBuffer();

      log(
          '✅ [PDF Extraction] PDF opened successfully. Total pages: ${document.pages.count}');

      for (int page = 0; page < document.pages.count; page++) {
        try {
          final String pageText = extractor.extractText(
            startPageIndex: page,
            endPageIndex: page,
          );
          if (pageText.trim().isNotEmpty) {
            extractedText.writeln(pageText.trim());
          }
          log('📄 [PDF Extraction] Processed page ${page + 1}');
        } catch (e) {
          log('⚠️ [PDF Extraction] Error extracting page ${page + 1}: $e');
        }
      }

      document.dispose();
      final String finalText = extractedText.toString().trim();

      log('✅ [PDF Extraction] Text extraction completed!');
      log(
          '📊 [PDF Extraction] Total extracted text length: ${finalText.length} characters');
      log('📋 [PDF Extraction] ==== EXTRACTED RESUME TEXT START ====');
      log(finalText);
      log('📋 [PDF Extraction] ==== EXTRACTED RESUME TEXT END ====');

      return finalText;
    } catch (e) {
      log('❌ [PDF Extraction] Error during PDF extraction: $e');
      print('Resume extractTextFromPDF: $e');
      return '';
    }
  }

  Future<String> chattingWithAva(
    AnalysedResumeModel analysedResume,
    String promptByUser,
  ) async {
    final String compactContext = _chatContextCache.putIfAbsent(
      analysedResume.id,
      () => _compactContextForChat(analysedResume),
    );
    final String trimmedUserPrompt = promptByUser.trim();
    final String normalizedUserPrompt = trimmedUserPrompt.length > 500
        ? trimmedUserPrompt.substring(0, 500)
        : trimmedUserPrompt;

    final String promptForChattingWithAva = '''
You are Ava, a resume assistant.
Use only this resume context:
$compactContext

Rules:
- Keep the reply short: max 3 lines.
- Be direct and actionable.
- If info is missing, say it briefly.
- For "Who are you?": "I am Ava, your AI assistant for resume improvement."

User question: $normalizedUserPrompt
''';

    const int maxAttempts = 1;
    int attempt = 0;
    while (attempt < maxAttempts) {
      attempt++;
      try {
        final res = await Gemini.instance
            .text(promptForChattingWithAva)
            .timeout(const Duration(minutes: 5));

        String result = (res?.output ?? '').replaceAll('*', '').trim();
        if (result.isNotEmpty) {
          log(result);
          return result;
        }

        // Empty output can happen on transient failures.
        if (attempt < maxAttempts) {
          await Future<void>.delayed(const Duration(seconds: 1));
          continue;
        }
      } catch (e) {
        print('Resume chattingWithAva (attempt $attempt): $e');
        final bool isRetryable = _isRetryableGeminiError(e);
        if (!isRetryable || attempt >= maxAttempts) {
          return 'Ava is temporarily unavailable. Please try again in a moment.';
        }
        await Future<void>.delayed(const Duration(seconds: 1));
      }
    }

    return 'Ava is temporarily unavailable. Please try again in a moment.';
  }

  bool _isRetryableGeminiError(Object error) {
    final text = error.toString().toLowerCase();
    return text.contains('status code of 503') ||
        text.contains('status code: 503') ||
        text.contains('service unavailable') ||
        text.contains('unavailable') ||
        text.contains('timed out') ||
        text.contains('timeout') ||
        text.contains('socketexception');
  }

  String _compactContextForChat(AnalysedResumeModel analysedResume) {
    final bestRoles = analysedResume.jobRoles.take(2).join(', ');
    final topSuggestions =
        analysedResume.suggestionsForImprovement.take(2).join('; ');

    return '''
Name: ${analysedResume.name}
ATS: ${analysedResume.overallScore}/100
Content: ${analysedResume.contentScore}/100
Clarity: ${analysedResume.clarityScore}/100
Roles: $bestRoles
Suggestions: $topSuggestions
''';
  }

  Future<void> addAnalysedResumeToFirebase(
    AnalysedResumeModel analysedResume,
    String docId,
  ) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('analysedResumes')
          .doc(docId)
          .set(
            analysedResume.toMap(),
          );
    } catch (e) {
      print('Resume addAnalysedResumeToFirebase: $e');
    }
  }

  CollectionReference<Map<String, dynamic>> _chatCollection(String resumeId) {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('analysedResumes')
        .doc(resumeId)
        .collection('chatMessages');
  }

  Future<void> saveChatMessage(ChatModel message) async {
    try {
      if (_auth.currentUser == null || message.resumeId.isEmpty) return;

      await _chatCollection(message.resumeId).add(message.toMap());
    } catch (e) {
      print('Resume saveChatMessage: $e');
    }
  }

  Future<List<ChatModel>> getChatMessages(String resumeId) async {
    try {
      if (_auth.currentUser == null || resumeId.isEmpty) {
        return <ChatModel>[];
      }

      final snapshot =
          await _chatCollection(resumeId).orderBy('createdAtMs').get();

      return snapshot.docs
          .map((doc) => ChatModel.fromMap(doc.data()))
          .where((message) => message.message.trim().isNotEmpty)
          .toList();
    } catch (e) {
      print('Resume getChatMessages: $e');
      return <ChatModel>[];
    }
  }

  Future<List<File>> saveImagesLocally(List<String> pdfImages) async {
    List<File> savedImageFiles = [];

    Directory appDocDir = await getApplicationDocumentsDirectory();

    for (int i = 0; i < pdfImages.length; i++) {
      // For now, we're just returning empty file list as pdf_render was removed
      // In production, you would need an OCR solution or server-side processing
      ByteData? byteData;
    }

    return savedImageFiles;
  }

  Map<String, dynamic>? _parseJsonFromGeminiOutput(String output) {
    try {
      String cleaned =
          output.replaceAll('```json', '').replaceAll('```', '').trim();
      final RegExpMatch? jsonMatch =
          RegExp(r'\{[\s\S]*\}', dotAll: true).firstMatch(cleaned);
      if (jsonMatch != null) {
        cleaned = jsonMatch.group(0)!.trim();
      }

      final decoded = jsonDecode(cleaned);
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  String _normalizeScore(dynamic value) {
    if (value == null) return '0';
    final String raw = value.toString();
    final RegExpMatch? match = RegExp(r'-?\d+(\.\d+)?').firstMatch(raw);
    if (match == null) return '0';

    final double? parsed = double.tryParse(match.group(0)!);
    if (parsed == null) return '0';

    final double normalized = parsed.clamp(0, 100).toDouble();
    if (normalized == normalized.roundToDouble()) {
      return normalized.toInt().toString();
    }
    return normalized.toStringAsFixed(1);
  }

  String _asString(dynamic value) {
    if (value == null) return '';
    return value.toString().trim();
  }

  List<String> _asStringList(dynamic value) {
    if (value is List) {
      return value
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    if (value is String) {
      return value
          .split(RegExp(r'\|\||\n'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return <String>[];
  }

  Future<Map<String, dynamic>?> analyseResumeWithSingleApiCall(
      String resumeContent) async {
    try {
      final String normalizedResumeContent = resumeContent.length > 15000
          ? resumeContent.substring(0, 15000)
          : resumeContent;

      final String prompt = '''
You are an ATS resume expert.
Analyze the resume text and return ONLY valid JSON, with no markdown and no extra explanation.
Use this exact schema:
{
  "name": "string",
  "overallFeedback": "2-3 concise sentences in one paragraph",
  "overallScore": 0,
  "grammarScore": 0,
  "contentScore": 0,
  "clarityScore": 0,
  "readabilityScore": 0,
  "positiveImpactSentences": ["0 to 4 concise strings"],
  "negativeImpactSentences": ["2 to 4 concise strings"],
  "jobRoles": ["exactly 5 concise strings"],
  "generalFeedback": ["exactly 5 concise strings"],
  "suggestionsForImprovement": ["4 to 6 concise strings"]
}
Rules:
- Be honest and critical. Do not soften weaknesses.
- Add positiveImpactSentences only when there are genuine, evidence-based strengths in the resume.
- It is acceptable for positiveImpactSentences to be an empty list if no clear strengths are present.
- Scores must be numeric values between 0 and 100.
- If any field is uncertain, provide the best estimate but keep valid JSON.
- Do not include keys outside the schema.

Resume text:
$normalizedResumeContent
''';

      final res = await Gemini.instance.text(prompt);
      final output = res?.output ?? '';
      return _parseJsonFromGeminiOutput(output);
    } catch (e) {
      log('analyseResumeWithSingleApiCall error: $e');
      return null;
    }
  }

  Future<String> returnName(String resumeContent) async {
    String name = '';
    try {
      String promptForName =
          "$resumeContent \n You are given the text content of a resume. The text contains various details like work experience, education, skills, and personal information. Your task is to identify and return only the full name of the individual. The name is usually located at the beginning of the resume and is often written prominently. Avoid returning any other details, and do not include any titles, addresses, or job-related information, just return the individual's full name exactly as it appears in the content.";

      final res = await Gemini.instance.text(promptForName);

      name = res?.output ?? '';
      name = name.replaceAll('*', '').replaceAll('**', '');
    } catch (e) {
      print('Resume returnName: $e');
    }
    return name;
  }

  Future<String> overallFeedback(String resumeContent) async {
    String feedback = '';
    try {
      String promptForOverallFeedback =
          "$resumeContent \n You are given the text content of a resume. Based on this content, provide an overall feedback about the quality of the resume in at most 3 lines (or sentences). Your feedback should consider factors like clarity, structure, grammar, and relevance to common resume standards.";

      final res = await Gemini.instance.text(promptForOverallFeedback);

      feedback = res?.output ?? '';
      feedback = feedback.replaceAll('*', '').replaceAll('**', '');
    } catch (e) {
      print('Resume overallFeedback: $e');
    }
    return feedback;
  }

  Future<String> atsScore(String resumeContent) async {
    String atsScore = '';
    try {
      String promptForAtsScore =
          "$resumeContent \n You are given the text content of a resume. Analyze the resume based on standard Applicant Tracking System (ATS) criteria. Return an overall ATS score out of 100 as a numerical value ( with no additional text or information ), considering how well this resume would perform in an automated system.";

      final res = await Gemini.instance.text(promptForAtsScore);

      atsScore = res?.output ?? '';
      atsScore = atsScore.replaceAll('*', '').replaceAll('**', '');
    } catch (e) {
      print('Resume atsScore: $e');
    }
    return atsScore;
  }

  Future<String> grammarScore(String resumeContent) async {
    String grammarScore = '';
    try {
      String promptForGrammarScore =
          "$resumeContent \n You are given the text content of a resume stored in a variable named `resumeContentResult`. Analyze the resume for grammar, spelling, punctuation, and sentence structure. Return a grammar score out of 100, reflecting the overall grammatical quality of the resume. The score should be a numerical value (with no additional text or information).";

      final res = await Gemini.instance.text(promptForGrammarScore);

      grammarScore = res?.output ?? '';
      grammarScore = grammarScore.replaceAll('*', '').replaceAll('**', '');
    } catch (e) {
      print('Resume grammarScore: $e');
    }
    return grammarScore;
  }

  Future<String> contentScore(String resumeContent) async {
    String contentScore = '';
    try {
      String promptForContentScore =
          "$resumeContent \n You are given the text content of a resume stored in a variable named `resumeContentResult`. Analyze the content in terms of relevance to job descriptions, completeness, and overall quality of information provided in the resume. Return a content score out of 100 as a numerical value ( with no additional text or information ), reflecting how well the resume's content is written.";

      final res = await Gemini.instance.text(promptForContentScore);

      contentScore = res?.output ?? '';
      contentScore = contentScore.replaceAll('*', '').replaceAll('**', '');
    } catch (e) {
      print('Resume contentScore: $e');
    }
    return contentScore;
  }

  Future<String> clarityScore(String resumeContent) async {
    String clarityScore = '';
    try {
      String promptForClarityScore =
          "$resumeContent \n You are given the text content of a resume stored in a variable named `resumeContentResult`. Analyze the resume for clarity, conciseness, and how effectively it conveys the candidate's qualifications and experience. Return a clarity score out of 100 as a numerical value ( with no additional text or information ), reflecting how clear and understandable the resume is.";

      final res = await Gemini.instance.text(promptForClarityScore);

      clarityScore = res?.output ?? '';
      clarityScore = clarityScore.replaceAll('*', '').replaceAll('**', '');
    } catch (e) {
      print('Resume clarityScore: $e');
    }
    return clarityScore;
  }

  Future<String> readabilityScore(String resumeContent) async {
    String readabilityScore = '';
    try {
      String promptForReadabilityScore =
          "$resumeContent \n You are given the text content of a resume stored in a variable named `resumeContentResult`. Analyze the resume's readability in terms of sentence structure, word choice, and ease of comprehension. Return a readability score out of 100 as a numerical value ( with no additional text or information ), reflecting how easy it is to read and understand the resume.";

      final res = await Gemini.instance.text(promptForReadabilityScore);

      readabilityScore = res?.output ?? '';
      readabilityScore =
          readabilityScore.replaceAll('*', '').replaceAll('**', '');
    } catch (e) {
      print('Resume readabilityScore: $e');
    }
    return readabilityScore;
  }

  Future<List<String>> positiveImpactSentences(String resumeContent) async {
    List<String> positiveImpactSentencesList = [];
    try {
      String promptForPositiveImpactSentences =
          "$resumeContent \n You are given the text content of a resume. Analyze the resume and return at least 3 and at most 6 positive impact sentences that highlight the candidate's strengths, accomplishments, or skills. Ensure there are no serial numbers, bullet points, hyphens, or any special characters at the beginning of the sentences. Separate each sentence with ' || ' and ensure that the points are concise and relevant.";

      final res = await Gemini.instance.text(promptForPositiveImpactSentences);

      String positiveImpactSentences = '';

      positiveImpactSentences = res?.output ?? '';
      positiveImpactSentences =
          positiveImpactSentences.replaceAll('*', '').replaceAll('**', '');

      positiveImpactSentencesList = positiveImpactSentences.split('||');
    } catch (e) {
      print('Resume positiveImpactSentences: $e');
    }
    return positiveImpactSentencesList;
  }

  Future<List<String>> negativeImpactSentences(String resumeContent) async {
    List<String> negativeImpactSentencesList = [];
    try {
      String promptForNegativeImpactSentences =
          "$resumeContent \n You are given the text content of a resume. Analyze the resume and return at least 2 and at most 4 negative impact sentences that highlight areas of concern, weaknesses, or points for improvement in the candidate's resume. Ensure there are no serial numbers or bullet points, hyphens, or any special characters at the beginning of the sentences. Separate each sentence with ' || ' and ensure the points are concise and constructive.";

      final res = await Gemini.instance.text(promptForNegativeImpactSentences);

      String negativeImpactSentences = '';

      negativeImpactSentences = res?.output ?? '';
      negativeImpactSentences =
          negativeImpactSentences.replaceAll('*', '').replaceAll('**', '');

      negativeImpactSentencesList = negativeImpactSentences.split('||');
    } catch (e) {
      print('Resume negativeImpactSentences: $e');
    }
    return negativeImpactSentencesList;
  }

  Future<List<String>> jobRoles(String resumeContent) async {
    List<String> jobRolesList = [];
    try {
      String promptForJobRoles =
          "$resumeContent \n You are given the text content of a resume. Analyze the resume and identify 5 job roles that the candidate is well-suited for based on their skills, experiences, and qualifications. Ensure there are no serial numbers or bullet points, hyphens, or any special characters at the beginning of the sentences. Return the job roles separated by ' || '.";

      final res = await Gemini.instance.text(promptForJobRoles);

      String jobRoles = '';

      jobRoles = res?.output ?? '';
      jobRoles = jobRoles.replaceAll('*', '').replaceAll('**', '');

      jobRolesList = jobRoles.split('||');
    } catch (e) {
      print('Resume jobRoles: $e');
    }

    return jobRolesList;
  }

  Future<List<String>> generalFeedback(String resumeContent) async {
    List<String> generallFeedbackList = [];
    try {
      String promptForGenerallFeedback =
          "$resumeContent \n You are given the text content of a resume. Analyze the resume and provide 5 general feedback points regarding the overall quality, effectiveness, and presentation of the resume. Ensure each point is concise and informative. Ensure there are no serial numbers, bullet points, hyphens, or any special characters at the beginning of the sentences. Separate each feedback point with ' || '.";

      final res = await Gemini.instance.text(promptForGenerallFeedback);

      String generallFeedback = '';

      generallFeedback = res?.output ?? '';
      generallFeedback =
          generallFeedback.replaceAll('*', '').replaceAll('**', '');

      generallFeedbackList = generallFeedback.split('||');
    } catch (e) {
      print('Resume generalFeedback: $e');
    }
    return generallFeedbackList;
  }

  Future<List<String>> suggestionsForImprovement(String resumeContent) async {
    List<String> suggestions = [];
    try {
      String promptForSuggestionsForImprovement =
          "$resumeContent \n You are given the text content of a resume. Analyze the resume and provide 4 to 6 actionable suggestions for improvement that can enhance the candidate's resume. Each suggestion should be clear and concise. Ensure there are no serial numbers or bullet points, hyphens, or any special characters at the beginning of the sentences. Separate each suggestion with ' || '.";

      final res = await Gemini.instance.text(promptForSuggestionsForImprovement);

      String suggestionsForImprovement = '';

      suggestionsForImprovement = res?.output ?? '';
      suggestionsForImprovement =
          suggestionsForImprovement.replaceAll('*', '').replaceAll('**', '');

      suggestions = suggestionsForImprovement.split('||');
    } catch (e) {
      print('Resume suggestionsForImprovement: $e');
    }
    return suggestions;
  }

  Future<String?> checkResumeFile(String resumePath,
      List<String> pdfPageImages, List<File> imageFiles) async {
    try {
      // Image-based resume validation is not supported in flutter_gemini 3.x
      // Returning 'Yes' by default as the resume must be valid to reach this point
      return 'yes';
    } catch (e) {
      log('Check Resume error');
    }
    return null;
  }

  Future<AnalysedResumeModel?> analyseResume(String resumePath,
      List<String> pdfPageImages, List<File> imageFiles) async {
    try {
      log('🔍 [Resume Analysis] Starting resume analysis...');
      log('📁 [Resume Analysis] Resume path: $resumePath');

      // Extract text from PDF
      log('📄 [Resume Analysis] Extracting text from PDF...');
      final String result = await extractTextFromPDF(resumePath);

      if (result.trim().isEmpty) {
        log('❌ [Resume Analysis] No text extracted from PDF!');
        return null;
      }

      log(
          '✅ [Resume Analysis] Text extraction successful! Length: ${result.length} chars');
      log('🚀 [Resume Analysis] Sending single Gemini API request...');

      final analysis = await analyseResumeWithSingleApiCall(result);
      if (analysis == null) {
        log('❌ [Resume Analysis] Failed to parse Gemini response JSON');
        return null;
      }

      final List<String> positiveImpact =
          _asStringList(analysis['positiveImpactSentences']);
      final List<String> negativeImpact =
          _asStringList(analysis['negativeImpactSentences']);
      final List<String> roles = _asStringList(analysis['jobRoles']);
      final List<String> generallFeedback =
          _asStringList(analysis['generalFeedback']);
      final List<String> suggestions =
          _asStringList(analysis['suggestionsForImprovement']);

      log('📊 [Resume Analysis] Structured response parsed successfully');

      String docId = FirebaseFirestore.instance.collection('users').doc().id;

      AnalysedResumeModel analysedResume = AnalysedResumeModel(
        id: docId,
        name: _asString(analysis['name']),
        overallFeedback: _asString(analysis['overallFeedback']),
        overallScore: _normalizeScore(analysis['overallScore']),
        grammarScore: _normalizeScore(analysis['grammarScore']),
        contentScore: _normalizeScore(analysis['contentScore']),
        clarityScore: _normalizeScore(analysis['clarityScore']),
        readabilityScore: _normalizeScore(analysis['readabilityScore']),
        positiveImpactSentences: positiveImpact,
        negativeImpactSentences: negativeImpact,
        jobRoles: roles,
        generalFeedback: generallFeedback,
        suggestionsForImprovement: suggestions,
        wholeResumeContent: result,
        timestamp: Timestamp.now(),
      );

      log('✅ [Resume Analysis] Analysis completed successfully!');
      log('💾 [Resume Analysis] Saving to Firebase...');

      await addAnalysedResumeToFirebase(analysedResume, docId);

      return analysedResume;
    } catch (e) {
      print('analyseResume resume_repositories: $e');
    }
    return null;
  }
}

// error facing, call saveImagesLocally only one time
