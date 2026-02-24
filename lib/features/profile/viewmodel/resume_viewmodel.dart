// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/common/provider/current_resumemodel.dart';
import '../../../core/common/upload_resume.dart';
import '../../../core/utils.dart';
import '../model/resume_model.dart';
import '../repositories/resume_repositories.dart';

class ResumeViewmodel with ChangeNotifier {
  final ResumeRepositories _resumeRepositories = ResumeRepositories();
  final UploadResume _uploadResume = UploadResume();

  String? _resumePath;
  List<String>? _pdfPageImages;
  bool _isLoading = false;
  String? _createdResumePath;

  String? get resumePath => _resumePath;
  List<String>? get pdfPageImages => _pdfPageImages;
  bool get isLoading => _isLoading;
  String? get createdResumePath => _createdResumePath;

  void uploadResume() async {
    try {
      _resumePath = await _uploadResume.uploadResume();
      if (_resumePath == null) {
        _pdfPageImages = null;
        notifyListeners();
        return;
      }
      notifyListeners();

      _pdfPageImages = await _uploadResume.convertPDFToImages(_resumePath!);
      notifyListeners();
    } catch (e) {
      log('ResumeViewmodel: $e');
    }
  }

  void removeResumePath() {
    _resumePath = null;
    notifyListeners();
  }

  void deleteCurrentResume(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    bool res = await _resumeRepositories.deleteCurrentResume(context);

    if (res) {
      _isLoading = false;
      notifyListeners();

      showSnackBar(context, 'Resume deleted successfully');
    } else {
      _isLoading = false;
      notifyListeners();

      showSnackBar(context, 'Error deleting resume');
    }
  }

  void submitResume(ResumeModel resumeModel, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    bool resumeSaved =
        await _resumeRepositories.saveResume(resumeModel, context);

    if (resumeSaved) {
      _isLoading = false;
      notifyListeners();

      showSnackBar(context, 'Resume saved successfully');

      // createResumePDF(context);

      Navigator.of(context).pop();
    } else {
      showSnackBar(context, 'Error saving resume');
    }

    _isLoading = false;
    notifyListeners();
  }

  void getResumeFromFirestore(BuildContext context) async {
    ResumeModel resumeModel = await _resumeRepositories.getResume();

    context.read<CurrentResumemodel>().setResumeModel(resumeModel);

    log('Resume Model Set Success',
        name: 'ResumeViewModel getResumeFromFirestore');
  }

  void createResumePDF(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    _createdResumePath = await _resumeRepositories.createResumePDF(context);
    notifyListeners();

    if (_createdResumePath != null) {
      generateAndSavePdf();

      showSnackBar(context, 'Resume PDF created successfully');
      log('$_createdResumePath', name: 'ResumeViewModel createResumePDF');
    } else {
      log('Error creating resume PDF', name: 'ResumeViewModel createResumePDF');
    }

    _isLoading = false;
    notifyListeners();
  }

  void generateAndSavePdf() async {
    try {
      var box = Hive.box('pdfPathsBox');

      await box.put('resume_pdf_path', _createdResumePath);
    } catch (e) {
      log('ResumeViewmodel generateAndSavePdf: $e');
    }
  }

  void getPdfPath() async {
    try {
      var box = Hive.box('pdfPathsBox');

      _createdResumePath = box.get('resume_pdf_path');
      notifyListeners();

      log('Got Resume Pdf Path Success');
    } catch (e) {
      log('ResumeViewmodel getPdfPath: $e');
    }
  }

  // void readPdfContent() {
  //   try {
  //     PdfDocument document =
  //         PdfDocument(inputBytes: File(_resumePath!).readAsBytesSync());

  //     String text = PdfTextExtractor(document).extractText(startPageIndex: 0);

  //     document.dispose();

  //     log(text, name: 'PDF Text');
  //   } catch (e) {
  //     log('ResumeViewmodel readPdfContent: $e');
  //   }
  // }
}
