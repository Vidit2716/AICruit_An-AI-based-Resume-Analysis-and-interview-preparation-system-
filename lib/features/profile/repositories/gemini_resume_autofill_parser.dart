import 'dart:convert';
import 'dart:developer';

import 'package:flutter_gemini/flutter_gemini.dart';

import '../model/resume_model.dart';

class GeminiResumeAutofillParser {
  Future<ResumeModel?> parse({
    required String resumeText,
    required ResumeModel baseResume,
  }) async {
    try {
      final normalizedText = resumeText.trim().length > 18000
          ? resumeText.trim().substring(0, 18000)
          : resumeText.trim();

      if (normalizedText.isEmpty) return null;

      final prompt = '''
You are an expert resume parser.
Read the resume text and return ONLY valid JSON. No markdown, no explanation.

Use this exact schema:
{
  "firstName": "string",
  "lastName": "string",
  "bio": "string",
  "yearsOfExp": "string",
  "email": "string",
  "phone": "string",
  "skills": ["string"],
  "portfolioLink": "string",
  "linkedinLink": "string",
  "githubLink": "string",
  "otherLink": "string",
  "projectsControllers": [
    { "projectTitle": "string", "description": "string" }
  ],
  "workExperienceControllers": [
    { "companyName": "string", "position": "string", "description": "string" }
  ],
  "educationControllers": [
    {
      "instituteName": "string",
      "courseName": "string",
      "score": "string",
      "passYear": "string"
    }
  ],
  "achievementsControllers": [
    { "achievement": "string", "description": "string" }
  ]
}

Rules:
- If a value is unknown, return empty string "" or [].
- Do not invent facts.
- Keep extracted text concise and clean.
- Output must be parseable JSON.
- Do not add any extra keys.

Resume text:
$normalizedText
''';

      final response = await Gemini.instance.text(prompt);
      final output = (response?.output ?? '').trim();
      if (output.isEmpty) return null;

      final decoded = _parseJsonFromGeminiOutput(output);
      if (decoded == null) return null;

      final firstName = _pick(decoded['firstName'], baseResume.firstName);
      final lastName = _pick(decoded['lastName'], baseResume.lastName);

      return ResumeModel(
        firstName: firstName,
        lastName: lastName,
        bio: _pick(decoded['bio'], baseResume.bio),
        yearsOfExp: _pick(decoded['yearsOfExp'], baseResume.yearsOfExp),
        email: _pick(decoded['email'], baseResume.email),
        phone: _pick(decoded['phone'], baseResume.phone),
        skills: _pickList(decoded['skills'], baseResume.skills),
        portfolioLink: _pick(decoded['portfolioLink'], baseResume.portfolioLink),
        linkedinLink: _pick(decoded['linkedinLink'], baseResume.linkedinLink),
        githubLink: _pick(decoded['githubLink'], baseResume.githubLink),
        otherLink: _pick(decoded['otherLink'], baseResume.otherLink),
        gender: baseResume.gender,
        maritalStatus: baseResume.maritalStatus,
        projectsControllers: _pickMapList(
          decoded['projectsControllers'],
          baseResume.projectsControllers,
        ),
        workExperienceControllers: _pickMapList(
          decoded['workExperienceControllers'],
          baseResume.workExperienceControllers,
        ),
        educationControllers: _pickMapList(
          decoded['educationControllers'],
          baseResume.educationControllers,
        ),
        achievementsControllers: _pickMapList(
          decoded['achievementsControllers'],
          baseResume.achievementsControllers,
        ),
      );
    } catch (e) {
      log(
        'GeminiResumeAutofillParser parse error: $e',
        name: 'GeminiResumeAutofillParser.parse',
      );
      return null;
    }
  }

  Map<String, dynamic>? _parseJsonFromGeminiOutput(String output) {
    try {
      String cleaned =
          output.replaceAll('```json', '').replaceAll('```', '').trim();

      final jsonMatch = RegExp(r'\{[\s\S]*\}', dotAll: true).firstMatch(cleaned);
      if (jsonMatch != null) {
        cleaned = jsonMatch.group(0)!.trim();
      }

      final decoded = jsonDecode(cleaned);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  String _pick(dynamic value, String? fallback) {
    final parsed = (value ?? '').toString().trim();
    if (parsed.isNotEmpty) return parsed;
    return (fallback ?? '').trim();
  }

  List<String> _pickList(dynamic value, List<String>? fallback) {
    final parsed = _asStringList(value);
    if (parsed.isNotEmpty) return parsed;
    return List<String>.from(fallback ?? <String>[]);
  }

  List<Map<String, String>> _pickMapList(
    dynamic value,
    List<Map<String, String>>? fallback,
  ) {
    final parsed = _asMapStringList(value);
    if (parsed.isNotEmpty) return parsed;
    return List<Map<String, String>>.from(fallback ?? <Map<String, String>>[]);
  }

  List<String> _asStringList(dynamic value) {
    if (value is! List) return <String>[];

    return value
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toSet()
        .toList();
  }

  List<Map<String, String>> _asMapStringList(dynamic value) {
    if (value is! List) return <Map<String, String>>[];

    final normalized = <Map<String, String>>[];
    for (final item in value) {
      if (item is! Map) continue;
      final map = <String, String>{};
      item.forEach((key, val) {
        map[key.toString()] = (val ?? '').toString().trim();
      });

      final hasAnyValue = map.values.any((v) => v.isNotEmpty);
      if (hasAnyValue) {
        normalized.add(map);
      }
    }

    return normalized;
  }
}
