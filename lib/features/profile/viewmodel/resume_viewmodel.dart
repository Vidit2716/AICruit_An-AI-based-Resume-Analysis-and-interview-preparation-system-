// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
  List<String> _createdResumePaths = [];
  int _selectedTemplateIndex = 0;

  String? get resumePath => _resumePath;
  List<String>? get pdfPageImages => _pdfPageImages;
  bool get isLoading => _isLoading;
  String? get createdResumePath => _createdResumePath;
  List<String> get createdResumePaths => _createdResumePaths;
  int get selectedTemplateIndex => _selectedTemplateIndex;

  void setSelectedTemplateIndex(int index) {
    _selectedTemplateIndex = index;
    notifyListeners();
  }

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

  Future<bool> autoFillProfileFromUploadedResume(BuildContext context) async {
    if (_resumePath == null || _resumePath!.isEmpty) {
      showSnackBar(context, 'Please upload a resume PDF first');
      return false;
    }

    _isLoading = true;
    notifyListeners();

    final baseResume = context.read<CurrentResumemodel>().resumeModel;
    final parsedResume = await _resumeRepositories.buildResumeModelFromUploadedPdf(
      resumePath: _resumePath!,
      baseResume: baseResume,
    );

    _isLoading = false;
    notifyListeners();

    if (parsedResume == null) {
      showSnackBar(
        context,
        'Could not auto-fill from this PDF. Please fill details manually.',
      );
      return false;
    }

    context.read<CurrentResumemodel>().setResumeModel(parsedResume);
    showSnackBar(context, 'Profile details auto-filled from resume');
    return true;
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
      _createdResumePath = await _resumeRepositories.createResumePDF(
        context,
        templateIndex: _selectedTemplateIndex,
      );
      notifyListeners();

      if (_createdResumePath != null) {
        await generateAndSavePdf();
        showSnackBar(context, 'Resume saved and PDF created successfully');
      } else {
        showSnackBar(
          context,
          'Resume saved successfully, but PDF creation failed',
        );
      }

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

    _createdResumePath = await _resumeRepositories.createResumePDF(
      context,
      templateIndex: _selectedTemplateIndex,
    );
    notifyListeners();

    if (_createdResumePath != null) {
      await generateAndSavePdf();

      showSnackBar(context, 'Resume PDF created successfully');
      log('$_createdResumePath', name: 'ResumeViewModel createResumePDF');
    } else {
      log('Error creating resume PDF', name: 'ResumeViewModel createResumePDF');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> generateAndSavePdf() async {
    try {
      var box = Hive.box('pdfPathsBox');
      if (_createdResumePath == null || _createdResumePath!.isEmpty) return;

      _createdResumePaths = box.get('resume_pdf_paths') != null
          ? List<String>.from(box.get('resume_pdf_paths'))
          : <String>[];

      _createdResumePaths.remove(_createdResumePath);
      _createdResumePaths.insert(0, _createdResumePath!);

      await box.put('resume_pdf_path', _createdResumePath);
      await box.put('resume_pdf_paths', _createdResumePaths);
      notifyListeners();
    } catch (e) {
      log('ResumeViewmodel generateAndSavePdf: $e');
    }
  }

  void getPdfPath() async {
    try {
      var box = Hive.box('pdfPathsBox');

      _createdResumePath = box.get('resume_pdf_path');
      _createdResumePaths = box.get('resume_pdf_paths') != null
          ? List<String>.from(box.get('resume_pdf_paths'))
          : <String>[];

      if (_createdResumePaths.isEmpty &&
          _createdResumePath != null &&
          _createdResumePath!.isNotEmpty) {
        _createdResumePaths = [_createdResumePath!];
      }

      notifyListeners();

      log('Got Resume Pdf Path Success');
    } catch (e) {
      log('ResumeViewmodel getPdfPath: $e');
    }
  }

  Future<void> removeGeneratedPdf(String path, BuildContext context) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }

      _createdResumePaths.remove(path);
      _createdResumePath =
          _createdResumePaths.isNotEmpty ? _createdResumePaths.first : null;

      final box = Hive.box('pdfPathsBox');
      await box.put('resume_pdf_paths', _createdResumePaths);
      await box.put('resume_pdf_path', _createdResumePath);

      notifyListeners();
      showSnackBar(context, 'PDF removed successfully');
    } catch (e) {
      log('ResumeViewmodel removeGeneratedPdf: $e');
      showSnackBar(context, 'Could not remove PDF');
    }
  }

  Future<void> downloadGeneratedPdf(String sourcePath, BuildContext context) async {
    try {
      final sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        showSnackBar(context, 'PDF not found');
        return;
      }

      Directory? targetDir;

      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt <= 32) {
          final storageStatus = await Permission.storage.request();
          if (!storageStatus.isGranted) {
            showSnackBar(context, 'Storage permission is required to download');
            return;
          }
        }

        final downloadsDirectory = Directory('/storage/emulated/0/Download');
        if (await downloadsDirectory.exists()) {
          targetDir = downloadsDirectory;
        } else {
          final externalDir = await getExternalStorageDirectory();
          if (externalDir != null) {
            targetDir = Directory('${externalDir.path}/Download');
          }
        }
      } else if (Platform.isIOS) {
        targetDir = await getApplicationDocumentsDirectory();
      } else {
        final home = Platform.environment['HOME'];
        if (home != null && home.isNotEmpty) {
          targetDir = Directory('$home/Downloads');
        }
      }

      if (targetDir == null) {
        showSnackBar(context, 'Could not access download directory');
        return;
      }

      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
      }

      final sourceName = sourceFile.uri.pathSegments.last;
      final fileNameNoExt = sourceName.toLowerCase().endsWith('.pdf')
          ? sourceName.substring(0, sourceName.length - 4)
          : sourceName;
      final targetPath =
          '${targetDir.path}/${fileNameNoExt}_${DateTime.now().millisecondsSinceEpoch}.pdf';

      await sourceFile.copy(targetPath);
      showSnackBar(context, 'PDF downloaded successfully');
    } catch (e) {
      log('ResumeViewmodel downloadGeneratedPdf: $e');
      showSnackBar(context, 'Failed to download PDF');
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
