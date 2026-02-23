// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:resume_ai/core/utils.dart';

import '../../../core/common/upload_resume.dart';
import '../model/analysed_resume_model.dart';
import '../model/chat_model.dart';
import '../repositories/resume_repositories.dart';
import '../view/pages/resume_insights_page.dart';

class ResumeViewmodel with ChangeNotifier {
  final ResumeRepositories _resumeRepositories = ResumeRepositories();
  final UploadResume _uploadResume = UploadResume();

  bool _isLoading = false;
  String? _resumePath;
  List<String>? _pdfPageImages;
  // final List<ChatModel> _chatMessages = [
  //   const ChatModel(message: 'How can i help you?', isMe: false),
  // ];

  bool get isLoading => _isLoading;
  String? get resumePath => _resumePath;
  List<String>? get pdfPageImages => _pdfPageImages;
  // List<ChatModel> get chatMessages => _chatMessages;

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
      log('uploadResume resume_viewmodel: $e');
    }
  }

  void removeResumePath() {
    _resumePath = null;
    notifyListeners();
  }

  Future<String> chattingWithAva(
    AnalysedResumeModel analysedResume,
    String promptByUser,
  ) async {
    return await _resumeRepositories.chattingWithAva(
      analysedResume,
      promptByUser,
    );
  }

  Future<void> saveChatMessage(ChatModel message) async {
    await _resumeRepositories.saveChatMessage(message);
  }

  Future<List<ChatModel>> getChatMessages(String resumeId) async {
    return await _resumeRepositories.getChatMessages(resumeId);
  }

  void clearEverything() {
    _isLoading = false;
    notifyListeners();

    _resumePath = null;
    notifyListeners();

    _pdfPageImages = null;
    notifyListeners();
  }

  void analyseResume(
    String resumePath,
    List<String> pdfPageImages,
    BuildContext context,
  ) async {
    _isLoading = true;
    notifyListeners();

    List<File> imageFiles = [];
    imageFiles = await _resumeRepositories.saveImagesLocally(pdfPageImages);

    try {
      String? isResume = await _resumeRepositories.checkResumeFile(
          resumePath, pdfPageImages, imageFiles);

      print('CHECK RESUME RESULT: ${isResume ?? ''}');

      if (isResume != null) {
        switch (isResume) {
          case 'yes.':
            AnalysedResumeModel? analysedResumeModel = await _resumeRepositories
                .analyseResume(resumePath, pdfPageImages, imageFiles);
            notifyListeners();
            if (analysedResumeModel == null) {
              showSnackBar(
                context,
                'Could not analyse this PDF. Please upload a text-based resume.',
              );
              clearEverything();
              return;
            }

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    ResumeInsightsPage(analysedResume: analysedResumeModel),
              ),
            );

            clearEverything();

            return;

          case 'yes':
            AnalysedResumeModel? analysedResumeModel = await _resumeRepositories
                .analyseResume(resumePath, pdfPageImages, imageFiles);
            notifyListeners();
            if (analysedResumeModel == null) {
              showSnackBar(
                context,
                'Could not analyse this PDF. Please upload a text-based resume.',
              );
              clearEverything();
              return;
            }

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    ResumeInsightsPage(analysedResume: analysedResumeModel),
              ),
            );

            clearEverything();

            return;

          case 'no.':
            Navigator.of(context).pop(true);
            showSnackBar(context, 'File uploaded is not a resume');

            clearEverything();

            return;

          case 'no':
            Navigator.of(context).pop(true);
            showSnackBar(context, 'File uploaded is not a resume');

            clearEverything();

            return;

          default:
            return;
        }
      } else {
        clearEverything();
      }

      clearEverything();
    } catch (e) {
      print('analyseResume resume_viewmodel: $e');
    }

    clearEverything();
  }
}
