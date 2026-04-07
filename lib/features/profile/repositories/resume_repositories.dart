// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../core/common/provider/current_resumemodel.dart';
import '../model/resume_model.dart';

class ResumeRepositories {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ResumeModel _emptyResumeModel() {
    return ResumeModel(
      firstName: '',
      lastName: '',
      bio: '',
      yearsOfExp: '',
      email: '',
      phone: '',
      skills: [],
      portfolioLink: '',
      linkedinLink: '',
      githubLink: '',
      otherLink: '',
      gender: 'Male',
      maritalStatus: 'Single',
      projectsControllers: [],
      workExperienceControllers: [],
      educationControllers: [],
      achievementsControllers: [],
    );
  }

  Future<bool> saveResume(ResumeModel resumeModel, BuildContext context) async {
    try {
      if (_auth.currentUser == null) return false;

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('resume')
          .doc(_auth.currentUser!.uid)
          .set(
            resumeModel.toMap(),
            SetOptions(merge: true),
          )
          .then(
        (value) {
          log('Resume saved', name: 'ResumeRepositories.saveResume');
        },
      );

      context.read<CurrentResumemodel>().setResumeModel(resumeModel);

      return true;
    } catch (e) {
      log(e.toString(), name: 'ResumeRepositories.saveResume');
      return false;
    }
  }

  Future<ResumeModel> getResume() async {
    if (_auth.currentUser == null) return _emptyResumeModel();

    DocumentSnapshot<Map<String, dynamic>> resumeDoc = await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('resume')
        .doc(_auth.currentUser!.uid)
        .get();

    final data = resumeDoc.data();
    if (data == null) return _emptyResumeModel();
    return ResumeModel.fromMap(data);
  }

  Future<bool> deleteCurrentResume(BuildContext context) async {
    try {
      if (_auth.currentUser == null) return false;

      ResumeModel resumeModel = _emptyResumeModel();

      context.read<CurrentResumemodel>().setResumeModel(resumeModel);

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('resume')
          .doc(_auth.currentUser!.uid)
          .set(
            resumeModel.toMap(),
            SetOptions(merge: true),
          );

      return true;
    } catch (e) {
      log(e.toString(), name: 'ResumeRepositories.deleteCurrentResume');

      return false;
    }
  }

  Future<String?> createResumePDF(
    BuildContext context, {
    int templateIndex = 0,
  }) async {
    ResumeModel resumeModel = context.read<CurrentResumemodel>().resumeModel;

    try {
      PdfDocument document = PdfDocument();

      document.pageSettings.size = PdfPageSize.a4;

      PdfPage page = document.pages.add();
      page.graphics.colorSpace = PdfColorSpace.rgb;
      final double margin = 28;
      double currentY = margin;
      final double contentWidth = page.getClientSize().width - (margin * 2);

      final List<PdfColor> templatePrimaryColors = [
        PdfColor(101, 45, 144),
        PdfColor(20, 90, 130),
        PdfColor(30, 110, 70),
      ];
      final PdfColor primaryColor =
          templatePrimaryColors[templateIndex % templatePrimaryColors.length];
      final PdfStandardFont headingFont =
          PdfStandardFont(PdfFontFamily.helvetica, 13, style: PdfFontStyle.bold);
      final PdfStandardFont subHeadingFont =
          PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.bold);
      final PdfStandardFont bodyFont =
          PdfStandardFont(PdfFontFamily.helvetica, 10);

      void ensureSpace(double heightNeeded) {
        final pageHeight = page.getClientSize().height;
        if (currentY + heightNeeded > pageHeight - margin) {
          page = document.pages.add();
          currentY = margin;
        }
      }

      PdfLayoutResult drawParagraph({
        required String text,
        required PdfFont font,
        PdfColor? color,
        PdfTextAlignment alignment = PdfTextAlignment.left,
        double spacingAfter = 6,
      }) {
        ensureSpace(40);
        final result = PdfTextElement(
          text: text,
          font: font,
          brush: PdfSolidBrush(color ?? PdfColor(0, 0, 0)),
          format: PdfStringFormat(alignment: alignment),
        ).draw(
          page: page,
          bounds: Rect.fromLTWH(margin, currentY, contentWidth, 0),
        )!;

        currentY = result.bounds.bottom + spacingAfter;
        return result;
      }

      void drawSectionTitle(String title) {
        ensureSpace(30);
        drawParagraph(
          text: title,
          font: headingFont,
          color: primaryColor,
          spacingAfter: 4,
        );
        page.graphics.drawLine(
          PdfPen(primaryColor, width: 0.7),
          Offset(margin, currentY),
          Offset(margin + contentWidth, currentY),
        );
        currentY += 8;
      }

      String clean(String? value) => (value ?? '').trim();
      bool nonEmpty(String? value) => clean(value).isNotEmpty;

      final fullName =
          '${clean(resumeModel.firstName)} ${clean(resumeModel.lastName)}'.trim();
      drawParagraph(
        text: fullName.isEmpty ? 'YOUR NAME' : fullName.toUpperCase(),
        font: PdfStandardFont(PdfFontFamily.helvetica, 20,
            style: PdfFontStyle.bold),
        color: primaryColor,
        alignment: PdfTextAlignment.center,
        spacingAfter: 4,
      );

      final headerContacts = [
        clean(resumeModel.phone),
        clean(resumeModel.email),
      ].where((e) => e.isNotEmpty).join('   |   ');

      if (headerContacts.isNotEmpty) {
        drawParagraph(
          text: headerContacts,
          font: PdfStandardFont(PdfFontFamily.helvetica, 10),
          alignment: PdfTextAlignment.center,
          spacingAfter: 8,
        );
      }

      page.graphics.drawLine(
        PdfPen(primaryColor, width: 1),
        Offset(margin, currentY),
        Offset(margin + contentWidth, currentY),
      );
      currentY += 10;

      if (nonEmpty(resumeModel.bio)) {
        drawSectionTitle('PROFESSIONAL SUMMARY');
        drawParagraph(text: clean(resumeModel.bio), font: bodyFont, spacingAfter: 8);
      }

      if ((resumeModel.skills ?? []).isNotEmpty) {
        drawSectionTitle('SKILLS');
        final skillsText = (resumeModel.skills ?? []).where(nonEmpty).join(' • ');
        if (skillsText.isNotEmpty) {
          drawParagraph(text: skillsText, font: bodyFont, spacingAfter: 8);
        }
      }

      if ((resumeModel.workExperienceControllers ?? []).isNotEmpty) {
        drawSectionTitle('WORK EXPERIENCE');
        for (final work in resumeModel.workExperienceControllers ?? []) {
          final company = clean(work['companyName']);
          final role = clean(work['position']);
          final description = clean(work['description']);
          if (company.isEmpty && role.isEmpty && description.isEmpty) continue;

          drawParagraph(
            text: [company, role].where((e) => e.isNotEmpty).join(' | '),
            font: subHeadingFont,
            spacingAfter: 2,
          );
          if (description.isNotEmpty) {
            drawParagraph(text: description, font: bodyFont, spacingAfter: 6);
          }
        }
      }

      if ((resumeModel.projectsControllers ?? []).isNotEmpty) {
        drawSectionTitle('PROJECTS');
        for (final project in resumeModel.projectsControllers ?? []) {
          final title = clean(project['projectTitle']);
          final description = clean(project['description']);
          if (title.isEmpty && description.isEmpty) continue;

          if (title.isNotEmpty) {
            drawParagraph(text: title, font: subHeadingFont, spacingAfter: 2);
          }
          if (description.isNotEmpty) {
            drawParagraph(text: description, font: bodyFont, spacingAfter: 6);
          }
        }
      }

      if ((resumeModel.educationControllers ?? []).isNotEmpty) {
        drawSectionTitle('EDUCATION');
        for (final education in resumeModel.educationControllers ?? []) {
          final institute = clean(education['instituteName']);
          final course = clean(education['courseName']);
          final passYear = clean(education['passYear']);
          final score = clean(education['score']);
          if (institute.isEmpty && course.isEmpty && passYear.isEmpty && score.isEmpty) {
            continue;
          }

          if (institute.isNotEmpty) {
            drawParagraph(text: institute, font: subHeadingFont, spacingAfter: 2);
          }
          final meta = [
            if (course.isNotEmpty) course,
            if (passYear.isNotEmpty) 'Year: $passYear',
            if (score.isNotEmpty) 'Score: $score',
          ].join(' | ');
          if (meta.isNotEmpty) {
            drawParagraph(text: meta, font: bodyFont, spacingAfter: 6);
          }
        }
      }

      if ((resumeModel.achievementsControllers ?? []).isNotEmpty) {
        drawSectionTitle('ACHIEVEMENTS');
        for (final achievement in resumeModel.achievementsControllers ?? []) {
          final title = clean(achievement['achievement']);
          final description = clean(achievement['description']);
          final row = [title, description].where((e) => e.isNotEmpty).join(' - ');
          if (row.isNotEmpty) {
            drawParagraph(text: '• $row', font: bodyFont, spacingAfter: 4);
          }
        }
      }

      final links = [
        if (nonEmpty(resumeModel.portfolioLink)) 'Portfolio: ${clean(resumeModel.portfolioLink)}',
        if (nonEmpty(resumeModel.linkedinLink)) 'LinkedIn: ${clean(resumeModel.linkedinLink)}',
        if (nonEmpty(resumeModel.githubLink)) 'GitHub: ${clean(resumeModel.githubLink)}',
        if (nonEmpty(resumeModel.otherLink)) 'Other: ${clean(resumeModel.otherLink)}',
      ];
      if (links.isNotEmpty) {
        drawSectionTitle('LINKS');
        for (final line in links) {
          drawParagraph(text: line, font: bodyFont, spacingAfter: 4);
        }
      }

      final personal = [
        if (nonEmpty(resumeModel.yearsOfExp)) 'Experience: ${clean(resumeModel.yearsOfExp)} years',
        if (nonEmpty(resumeModel.gender)) 'Gender: ${clean(resumeModel.gender)}',
        if (nonEmpty(resumeModel.maritalStatus))
          'Marital Status: ${clean(resumeModel.maritalStatus)}',
      ];
      if (personal.isNotEmpty) {
        drawSectionTitle('PERSONAL DETAILS');
        for (final line in personal) {
          drawParagraph(text: line, font: bodyFont, spacingAfter: 4);
        }
      }

      final List<int> bytes = document.saveSync();

      final Directory directory = await getApplicationDocumentsDirectory();
      final String path =
          '${directory.path}/resume_${DateTime.now().millisecondsSinceEpoch}.pdf';

      final File file = File(path);
      await file.writeAsBytes(bytes);

      document.dispose();

      return file.path;
    } catch (e) {
      log(e.toString(), name: 'ResumeRepositories.createResumePDF');
    }
    return null;
  }

  Future<ResumeModel?> buildResumeModelFromUploadedPdf({
    required String resumePath,
    required ResumeModel baseResume,
  }) async {
    try {
      final file = File(resumePath);
      if (!await file.exists()) {
        return null;
      }

      final bytes = await file.readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: bytes);
      final PdfTextExtractor extractor = PdfTextExtractor(document);
      final StringBuffer textBuffer = StringBuffer();

      for (int page = 0; page < document.pages.count; page++) {
        final pageText =
            extractor.extractText(startPageIndex: page, endPageIndex: page);
        if (pageText.trim().isNotEmpty) {
          textBuffer.writeln(pageText.trim());
        }
      }

      document.dispose();

      final fullText = textBuffer.toString();
      if (fullText.trim().isEmpty) {
        return null;
      }

      final List<String> lines = fullText
          .split('\n')
          .map(
            (line) => line
                .replaceAll(RegExp(r'^[\-\*\.\s]+'), '')
                .replaceAll(RegExp(r'\s+'), ' ')
                .trim(),
          )
          .where((line) => line.isNotEmpty)
          .toList();

      bool isHeadingLine(String line) {
        final original = line.trim();
        final l = original.toLowerCase();
        const headingKeys = [
          'summary',
          'objective',
          'profile',
          'skills',
          'technical skills',
          'education',
          'academic',
          'experience',
          'work experience',
          'professional experience',
          'projects',
          'certifications',
          'achievements',
          'awards'
        ];
        if (l.length <= 40 && headingKeys.any((k) => l == k || l.startsWith('$k '))) {
          return true;
        }
        final alpha = original.replaceAll(RegExp(r'[^A-Za-z]'), '');
        return alpha.isNotEmpty && alpha == alpha.toUpperCase() && l.length <= 32;
      }

      List<String> sectionLines(List<String> keys) {
        int start = -1;
        for (int i = 0; i < lines.length; i++) {
          final l = lines[i].toLowerCase();
          final isMatch = keys.any((k) => l == k || l.startsWith('$k:') || l.contains(k));
          if (isMatch && isHeadingLine(lines[i])) {
            start = i + 1;
            break;
          }
        }
        if (start == -1 || start >= lines.length) return <String>[];
        final result = <String>[];
        for (int i = start; i < lines.length; i++) {
          if (isHeadingLine(lines[i])) break;
          result.add(lines[i]);
        }
        return result;
      }

      final email =
          RegExp(r'[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}')
              .firstMatch(fullText)
              ?.group(0);

      String? phone = RegExp(r'(\+?\d[\d\s\-()]{8,}\d)')
          .firstMatch(fullText)
          ?.group(0)
          ?.replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      if (phone != null && phone.length > 20) {
        phone = null;
      }

      final links = RegExp(r'((?:https?:\/\/|www\.)[^\s]+)')
          .allMatches(fullText)
          .map((m) => m.group(0)!.trim())
          .toList();

      String? linkedinLink;
      String? githubLink;
      String? portfolioLink;
      String? otherLink;
      for (final link in links) {
        final normalized = link.toLowerCase();
        if (linkedinLink == null && normalized.contains('linkedin')) {
          linkedinLink = link;
          continue;
        }
        if (githubLink == null && normalized.contains('github')) {
          githubLink = link;
          continue;
        }
        if (portfolioLink == null) {
          portfolioLink = link;
          continue;
        }
        otherLink ??= link;
      }

      String? detectedName;
      for (final line in lines.take(8)) {
        final words = line.split(RegExp(r'\s+'));
        final hasDigits = RegExp(r'\d').hasMatch(line);
        final looksLikeHeading = line.endsWith(':') || line.length < 3;
        final containsContactTokens = line.contains('@') ||
            line.toLowerCase().contains('linkedin') ||
            line.toLowerCase().contains('github') ||
            line.toLowerCase().contains('www.');
        if (!hasDigits &&
            !looksLikeHeading &&
            !containsContactTokens &&
            words.length >= 2 &&
            words.length <= 4) {
          detectedName = line;
          break;
        }
      }

      String detectedFirstName = baseResume.firstName;
      String detectedLastName = baseResume.lastName;
      if (detectedName != null) {
        final parts = detectedName
            .replaceAll(RegExp(r'[^A-Za-z\s]'), ' ')
            .split(RegExp(r'\s+'))
            .where((part) => part.isNotEmpty)
            .toList();
        if (parts.isNotEmpty) {
          detectedFirstName = parts.first;
          detectedLastName =
              parts.length > 1 ? parts.skip(1).join(' ') : baseResume.lastName;
        }
      }

      String yearsOfExp = baseResume.yearsOfExp;
      final expMatch = RegExp(r'(\d{1,2})\+?\s*(?:years|year|yrs|yr)',
              caseSensitive: false)
          .firstMatch(fullText);
      if (expMatch != null) {
        yearsOfExp = expMatch.group(1) ?? yearsOfExp;
      }

      List<String> skills = List<String>.from(baseResume.skills ?? <String>[]);
      final skillsFromSection = <String>{};
      final skillSection = sectionLines(['skills', 'technical skills', 'core skills']);
      for (final line in skillSection) {
        for (final token in line.split(RegExp(r'[,|;/]'))) {
          final value = token.trim();
          if (value.isNotEmpty && value.length <= 30) {
            skillsFromSection.add(value);
          }
        }
      }
      const fallbackSkillKeywords = <String>[
        'flutter',
        'dart',
        'firebase',
        'python',
        'java',
        'c++',
        'javascript',
        'typescript',
        'react',
        'node',
        'sql',
        'mongodb',
        'aws',
        'docker',
        'git',
        'figma'
      ];
      final lowerResume = fullText.toLowerCase();
      for (final keyword in fallbackSkillKeywords) {
        if (lowerResume.contains(keyword)) {
          skillsFromSection.add(keyword.toUpperCase() == keyword
              ? keyword
              : '${keyword[0].toUpperCase()}${keyword.substring(1)}');
        }
      }
      if (skillsFromSection.isNotEmpty) {
        skills = skillsFromSection.toList();
      }

      final summarySection = sectionLines(['summary', 'professional summary', 'objective']);
      String bio = baseResume.bio;
      if (summarySection.isNotEmpty) {
        bio = summarySection.take(2).join(' ');
      }

      final educationControllers = <Map<String, String>>[];
      final educationSection = sectionLines(['education', 'academic']);
      if (educationSection.isNotEmpty) {
        Map<String, String>? current;
        for (final line in educationSection) {
          final year = RegExp(r'\b(19|20)\d{2}\b').firstMatch(line)?.group(0) ?? '';
          final scoreMatch = RegExp(
            r'((?:cgpa|gpa|percentage|percent|score)\s*[:\-]?\s*[0-9.]+%?)|([0-9.]+\s*%+)',
            caseSensitive: false,
          ).firstMatch(line);
          final scoreText = scoreMatch?.group(0) ?? '';

          final isInstitute = RegExp(
            r'(university|college|institute|school|academy)',
            caseSensitive: false,
          ).hasMatch(line);

          if (isInstitute) {
            if (current != null &&
                (current['instituteName']!.isNotEmpty ||
                    current['courseName']!.isNotEmpty)) {
              educationControllers.add(current);
            }
            current = {
              'instituteName': line,
              'courseName': '',
              'score': '',
              'passYear': '',
            };
            if (year.isNotEmpty) current['passYear'] = year;
            if (scoreText.isNotEmpty) current['score'] = scoreText;
            continue;
          }

          current ??= {
            'instituteName': '',
            'courseName': '',
            'score': '',
            'passYear': '',
          };
          if (current['courseName']!.isEmpty && !isInstitute) {
            current['courseName'] = line;
          } else {
            current['courseName'] =
                '${current['courseName']!} ${line}'.trim();
          }
          if (year.isNotEmpty && current['passYear']!.isEmpty) {
            current['passYear'] = year;
          }
          if (scoreText.isNotEmpty && current['score']!.isEmpty) {
            current['score'] = scoreText;
          }
        }

        if (current != null &&
            (current['instituteName']!.isNotEmpty ||
                current['courseName']!.isNotEmpty)) {
          educationControllers.add(current);
        }
      }

      final workExperienceControllers = <Map<String, String>>[];
      final experienceSection = sectionLines(
        ['work experience', 'experience', 'professional experience', 'employment'],
      );
      if (experienceSection.isNotEmpty) {
        for (int i = 0; i < experienceSection.length; i += 3) {
          final company = experienceSection[i];
          final position = i + 1 < experienceSection.length ? experienceSection[i + 1] : '';
          final description = i + 2 < experienceSection.length ? experienceSection[i + 2] : '';
          if (company.isEmpty && position.isEmpty && description.isEmpty) continue;
          workExperienceControllers.add({
            'companyName': company,
            'position': position,
            'description': description,
          });
          if (workExperienceControllers.length >= 4) break;
        }
      }

      final projectsControllers = <Map<String, String>>[];
      final projectSection = sectionLines(['projects', 'project']);
      if (projectSection.isNotEmpty) {
        for (int i = 0; i < projectSection.length; i++) {
          final line = projectSection[i];
          if (line.isEmpty) continue;
          final split = line.split(':');
          if (split.length > 1) {
            projectsControllers.add({
              'projectTitle': split.first.trim(),
              'description': split.sublist(1).join(':').trim(),
            });
          } else {
            final description =
                i + 1 < projectSection.length ? projectSection[i + 1] : '';
            projectsControllers.add({
              'projectTitle': line,
              'description': description,
            });
            i++;
          }
          if (projectsControllers.length >= 4) break;
        }
      }

      final achievementsControllers = <Map<String, String>>[];
      final achievementSection = sectionLines(['achievements', 'awards', 'certifications']);
      for (final line in achievementSection.take(4)) {
        achievementsControllers.add({
          'achievement': line,
          'description': '',
        });
      }

      return ResumeModel(
        firstName: detectedFirstName,
        lastName: detectedLastName,
        bio: bio,
        yearsOfExp: yearsOfExp,
        email: email ?? baseResume.email,
        phone: phone ?? baseResume.phone,
        skills: skills,
        portfolioLink: portfolioLink ?? (baseResume.portfolioLink ?? ''),
        linkedinLink: linkedinLink ?? (baseResume.linkedinLink ?? ''),
        githubLink: githubLink ?? (baseResume.githubLink ?? ''),
        otherLink: otherLink ?? (baseResume.otherLink ?? ''),
        gender: baseResume.gender,
        maritalStatus: baseResume.maritalStatus,
        projectsControllers: projectsControllers.isNotEmpty
            ? projectsControllers
            : List<Map<String, String>>.from(baseResume.projectsControllers ?? []),
        workExperienceControllers: workExperienceControllers.isNotEmpty
            ? workExperienceControllers
            : List<Map<String, String>>.from(baseResume.workExperienceControllers ?? []),
        educationControllers: educationControllers.isNotEmpty
            ? educationControllers
            : List<Map<String, String>>.from(baseResume.educationControllers ?? []),
        achievementsControllers: achievementsControllers.isNotEmpty
            ? achievementsControllers
            : List<Map<String, String>>.from(baseResume.achievementsControllers ?? []),
      );
    } catch (e) {
      log(e.toString(), name: 'ResumeRepositories.buildResumeModelFromUploadedPdf');
      return null;
    }
  }
}
