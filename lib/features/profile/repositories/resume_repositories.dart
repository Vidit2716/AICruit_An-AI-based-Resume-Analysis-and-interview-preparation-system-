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

  Future<bool> saveResume(ResumeModel resumeModel, BuildContext context) async {
    try {
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
          print('Resume saved');
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
    DocumentSnapshot<Map<String, dynamic>> resumeDoc = await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('resume')
        .doc(_auth.currentUser!.uid)
        .get();

    return ResumeModel.fromMap(resumeDoc.data()!);
  }

  Future<bool> deleteCurrentResume(BuildContext context) async {
    try {
      ResumeModel resumeModel = ResumeModel(
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

  Future<String?> createResumePDF(BuildContext context) async {
    ResumeModel resumeModel = context.read<CurrentResumemodel>().resumeModel;

    try {
      PdfDocument document = PdfDocument();

      document.pageSettings.size = PdfPageSize.a4;

      PdfPage page = document.pages.add();
      page.graphics.colorSpace = PdfColorSpace.rgb;

      // Name
      final PdfLayoutResult nameLayoutResult = PdfTextElement(
        text:
            '${resumeModel.firstName.toUpperCase()} ${resumeModel.lastName.toUpperCase()}',
        format: PdfStringFormat(alignment: PdfTextAlignment.center),
        font: PdfStandardFont(PdfFontFamily.helvetica, 26,
            style: PdfFontStyle.bold),
        brush: PdfSolidBrush(PdfColor(101, 45, 144)), // Purple text
      ).draw(
        page: page,
        bounds: Rect.fromLTWH(0, 20, page.getClientSize().width, 0),
      )!;

      // Phone Number, email id
      final PdfLayoutResult phoneLayoutResult = PdfTextElement(
        text: '${resumeModel.phone}  |  ${resumeModel.email}',
        format: PdfStringFormat(alignment: PdfTextAlignment.center),
        font: PdfStandardFont(PdfFontFamily.helvetica, 14),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      ).draw(
        page: page,
        bounds: Rect.fromLTWH(0, nameLayoutResult.bounds.bottom + 10,
            page.getClientSize().width, 0),
      )!;

      // draw line
      page.graphics.drawLine(
          PdfPen(PdfColor(101, 45, 144)),
          Offset(0, phoneLayoutResult.bounds.bottom + 10),
          Offset(page.getClientSize().width,
              phoneLayoutResult.bounds.bottom + 10));

      // Brief Summary (Bio)
      final PdfLayoutResult bioLayoutResult = PdfTextElement(
        text: 'BRIEF SUMMARY',
        format: PdfStringFormat(alignment: PdfTextAlignment.left),
        font: PdfStandardFont(PdfFontFamily.helvetica, 18,
            style: PdfFontStyle.bold),
        brush: PdfSolidBrush(PdfColor(101, 45, 144)),
      ).draw(
        page: page,
        bounds: Rect.fromLTWH(0, phoneLayoutResult.bounds.bottom + 25,
            page.getClientSize().width, 0),
      )!;

      PdfTextElement(
        text: resumeModel.bio,
        format: PdfStringFormat(alignment: PdfTextAlignment.left),
        font: PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      ).draw(
        page: page,
        bounds: Rect.fromLTWH(0, bioLayoutResult.bounds.bottom + 10,
            page.getClientSize().width, 0),
      );

      // Education Section
      final PdfLayoutResult educationTitleLayoutResult = PdfTextElement(
        text: 'EDUCATION',
        format: PdfStringFormat(alignment: PdfTextAlignment.left),
        font: PdfStandardFont(PdfFontFamily.helvetica, 18,
            style: PdfFontStyle.bold),
        brush: PdfSolidBrush(PdfColor(101, 45, 144)),
      ).draw(
        page: page,
        bounds: Rect.fromLTWH(0, bioLayoutResult.bounds.bottom + 120,
            page.getClientSize().width, 0),
      )!;

      int index = 1;
      for (Map<String, String> education
          in resumeModel.educationControllers ?? []) {
        PdfTextElement(
          text: '${education["instituteName"]}\n(${education["courseName"]})',
          format: PdfStringFormat(alignment: PdfTextAlignment.left),
          font: PdfStandardFont(PdfFontFamily.helvetica, 14,
              style: PdfFontStyle.bold),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        ).draw(
          page: page,
          bounds: Rect.fromLTWH(
              0,
              educationTitleLayoutResult.bounds.bottom + 10 * index,
              page.getClientSize().width,
              0),
        );

        PdfTextElement(
          text: '${education["passYear"]}',
          format: PdfStringFormat(alignment: PdfTextAlignment.right),
          font: PdfStandardFont(PdfFontFamily.helvetica, 12),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        ).draw(
          page: page,
          bounds: Rect.fromLTWH(
              0,
              educationTitleLayoutResult.bounds.bottom + 10 * index,
              page.getClientSize().width,
              0),
        );

        index = index + 5;
      }

      final List<int> bytes = document.saveSync();

      final Directory directory = await getApplicationDocumentsDirectory();
      final String path = '${directory.path}/output.pdf';

      final File file = File(path);
      await file.writeAsBytes(bytes);

      document.dispose();

      return file.path;
    } catch (e) {
      log(e.toString(), name: 'ResumeRepositories.createResumePDF');
    }
    return null;
  }
}
