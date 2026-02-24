import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../model/topic_model.dart';
import '../repositories/interview_repositories.dart';

class InterviewViewModel with ChangeNotifier {
  final InterviewRepositories _interviewRepositories = InterviewRepositories();
  final FlutterTts flutterTts = FlutterTts();
  bool _isAvaSpeaking = false;
  bool _isAvaReplying = false;
  bool _isPreparingSession = false;

  String _interviewDifficulty = 'Easy';
  String? _avaResponse;
  final List<Map<String, dynamic>> _interviewModelMap = [];
  TopicModel? _activeTopic;
  String _activeUserName = '';

  String get interviewDifficulty => _interviewDifficulty;
  String? get avaResponse => _avaResponse;
  List<Map<String, dynamic>> get interviewModelMap =>
      List<Map<String, dynamic>>.unmodifiable(_interviewModelMap);
  bool get isAvaSpeaking => _isAvaSpeaking;
  bool get isAvaReplying => _isAvaReplying;
  bool get isPreparingSession => _isPreparingSession;

  void setAvaSpeaking(bool avaSpeaks) {
    _isAvaSpeaking = avaSpeaks;
    notifyListeners();
  }

  Future<void> avaSpeaks(String message) async {
    if (message.trim().isEmpty) return;

    _isAvaSpeaking = true;
    notifyListeners();

    log(_isAvaSpeaking.toString());

    try {
      await flutterTts.setVolume(0.5);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setPitch(1);

      await flutterTts.speak(message);
      await flutterTts.awaitSpeakCompletion(true);

      log('Ava speaks : $message');
    } catch (e) {
      print(e.toString());
    }

    _isAvaSpeaking = false;
    notifyListeners();

    log(_isAvaSpeaking.toString());
  }

  Future<void> avaStop() async {
    await flutterTts.stop();

    _isAvaSpeaking = false;
    notifyListeners();
  }

  void setInterviewDifficulty(String difficulty) {
    _interviewDifficulty = difficulty;
    notifyListeners();
  }

  String _buildIntroMessage({
    required TopicModel topicModel,
    required String userName,
  }) {
    return "Hey, $userName. My name is Ava. I will take your mock interview on ${topicModel.topicName}. Please start by introducing yourself.";
  }

  String? _latestAvaMessage() {
    for (final item in _interviewModelMap.reversed) {
      final isUser = item['isUser'] == true;
      final message = item['message']?.toString().trim() ?? '';
      if (!isUser && message.isNotEmpty) {
        return message;
      }
    }
    return null;
  }

  Future<bool> startInterviewSession({
    required TopicModel topicModel,
    required String userName,
  }) async {
    bool shouldSpeakIntro = false;

    _isPreparingSession = true;
    _activeTopic = topicModel;
    _activeUserName = userName.trim().isEmpty ? 'there' : userName.trim();
    _avaResponse = null;
    notifyListeners();

    try {
      await avaStop();

      final history = await _interviewRepositories.getInterviewMessages(
        topicId: topicModel.id,
        difficultyLevel: _interviewDifficulty,
      );

      _interviewModelMap
        ..clear()
        ..addAll(history);

      if (_interviewModelMap.isEmpty) {
        shouldSpeakIntro = true;
        final intro = _buildIntroMessage(
          topicModel: topicModel,
          userName: _activeUserName,
        );
        await setInterviewModelMap(
          [
            {
              'message': intro,
              'isUser': false,
            }
          ],
        );
      }

      _avaResponse = _latestAvaMessage();
    } catch (e) {
      log('startInterviewSession viewmodel: $e');
    } finally {
      _isPreparingSession = false;
      notifyListeners();
    }

    return shouldSpeakIntro;
  }

  Future<bool> clearAndStartFreshSession({
    required TopicModel topicModel,
    required String userName,
  }) async {
    bool shouldSpeakIntro = false;

    _isPreparingSession = true;
    _activeTopic = topicModel;
    _activeUserName = userName.trim().isEmpty ? 'there' : userName.trim();
    _avaResponse = null;
    notifyListeners();

    try {
      await avaStop();

      await _interviewRepositories.clearInterviewConversation(
        topicId: topicModel.id,
        difficultyLevel: _interviewDifficulty,
      );

      _interviewModelMap.clear();

      final intro = _buildIntroMessage(
        topicModel: topicModel,
        userName: _activeUserName,
      );
      shouldSpeakIntro = true;

      await setInterviewModelMap(
        [
          {
            'message': intro,
            'isUser': false,
          }
        ],
      );

      _avaResponse = intro;
    } catch (e) {
      log('clearAndStartFreshSession viewmodel: $e');
    } finally {
      _isPreparingSession = false;
      notifyListeners();
    }

    return shouldSpeakIntro;
  }

  Future setInterviewModelMap(
      List<Map<String, dynamic>> interviewModelMap) async {
    final filtered = interviewModelMap
        .where(
          (item) => (item['message']?.toString().trim().isNotEmpty ?? false),
        )
        .map((item) => <String, dynamic>{
              'message': item['message'].toString().trim(),
              'isUser': item['isUser'] == true,
              'createdAtMs': DateTime.now().millisecondsSinceEpoch,
            })
        .toList();

    if (filtered.isEmpty) return;

    _interviewModelMap.addAll(filtered);

    if (_activeTopic != null) {
      for (final item in filtered) {
        await _interviewRepositories.saveInterviewMessage(
          topicId: _activeTopic!.id,
          topicName: _activeTopic!.topicName,
          difficultyLevel: _interviewDifficulty,
          message: item['message'].toString(),
          isUser: item['isUser'] == true,
        );
      }
    }

    notifyListeners();
  }

  void setAvaResponseToNull() {
    _avaResponse = null;
    notifyListeners();
  }

  Future<void> interviewWithAva(
    List<Map<String, dynamic>> interviewModelMap,
    String difficultyLevel,
    TopicModel topicModel,
  ) async {
    if (_isAvaReplying) return;

    _isAvaReplying = true;
    notifyListeners();
    try {
      _avaResponse = await _interviewRepositories.interviewWithAva(
        interviewModelMap: interviewModelMap,
        difficultyLevel: difficultyLevel,
        topicModel: topicModel,
      );
      notifyListeners();

      await setInterviewModelMap(
        [
          {
            'message': _avaResponse?.trim(),
            'isUser': false,
          }
        ],
      );

      if ((_avaResponse ?? '').trim().isNotEmpty) {
        await avaSpeaks(_avaResponse!);
      }
    } catch (e) {
      log('interview with ava again error viewmodel: $e');
    } finally {
      _isAvaReplying = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }
}
