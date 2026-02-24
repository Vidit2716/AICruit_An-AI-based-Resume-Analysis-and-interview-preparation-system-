import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'package:resume_ai/features/interview/model/topic_model.dart';

class InterviewRepositories {
  final Uri interviewUrl = Uri.parse('http://render.com/question-generation');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _conversationDocId(String topicId, String difficultyLevel) {
    final normalizedDifficulty = difficultyLevel
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '_');
    return '${topicId}_$normalizedDifficulty';
  }

  CollectionReference<Map<String, dynamic>> _conversationMessages({
    required String topicId,
    required String difficultyLevel,
  }) {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('interviewConversations')
        .doc(_conversationDocId(topicId, difficultyLevel))
        .collection('messages');
  }

  Future<void> saveInterviewMessage({
    required String topicId,
    required String topicName,
    required String difficultyLevel,
    required String message,
    required bool isUser,
  }) async {
    try {
      if (_auth.currentUser == null || message.trim().isEmpty) return;

      final now = DateTime.now().millisecondsSinceEpoch;
      final docRef = _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('interviewConversations')
          .doc(_conversationDocId(topicId, difficultyLevel));

      await docRef.set(
        {
          'topicId': topicId,
          'topicName': topicName,
          'difficultyLevel': difficultyLevel,
          'updatedAtMs': now,
        },
        SetOptions(merge: true),
      );

      await _conversationMessages(
        topicId: topicId,
        difficultyLevel: difficultyLevel,
      ).add(
        {
          'message': message.trim(),
          'isUser': isUser,
          'createdAtMs': now,
        },
      );
    } catch (e) {
      log('saveInterviewMessage repository: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getInterviewMessages({
    required String topicId,
    required String difficultyLevel,
  }) async {
    try {
      if (_auth.currentUser == null) return <Map<String, dynamic>>[];

      final snapshot = await _conversationMessages(
        topicId: topicId,
        difficultyLevel: difficultyLevel,
      ).orderBy('createdAtMs').get();

      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            return <String, dynamic>{
              'message': data['message']?.toString().trim() ?? '',
              'isUser': data['isUser'] == true,
              'createdAtMs': (data['createdAtMs'] as num?)?.toInt() ??
                  DateTime.now().millisecondsSinceEpoch,
            };
          })
          .where((item) => item['message'].toString().isNotEmpty)
          .toList();
    } catch (e) {
      log('getInterviewMessages repository: $e');
      return <Map<String, dynamic>>[];
    }
  }

  Future<void> clearInterviewConversation({
    required String topicId,
    required String difficultyLevel,
  }) async {
    try {
      if (_auth.currentUser == null) return;

      final docRef = _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('interviewConversations')
          .doc(_conversationDocId(topicId, difficultyLevel));

      while (true) {
        final snapshot = await _conversationMessages(
          topicId: topicId,
          difficultyLevel: difficultyLevel,
        ).limit(400).get();

        if (snapshot.docs.isEmpty) break;

        final batch = _firestore.batch();
        for (final doc in snapshot.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
      }

      await docRef.delete();
    } catch (e) {
      log('clearInterviewConversation repository: $e');
    }
  }

  Future<String> interviewWithAva({
    required List<Map<String, dynamic>> interviewModelMap,
    required String difficultyLevel,
    required TopicModel topicModel,
  }) async {
    try {
      final recentMessages = interviewModelMap.length > 8
          ? interviewModelMap.sublist(interviewModelMap.length - 8)
          : interviewModelMap;
      final conversationText = recentMessages
          .map((item) {
            final role = item['isUser'] == true ? 'User' : 'Ava';
            final message = item['message']?.toString().trim() ?? '';
            return '$role: $message';
          })
          .where((line) => line.trim().isNotEmpty)
          .join('\n');

      String promptForInterview = '''
You are Ava, a professional interviewer.
Topic: ${topicModel.topicName}
Subtopics: ${topicModel.subTopics}
Difficulty: $difficultyLevel

Rules:
- Reply in 1-2 short sentences.
- First give brief feedback on user's last answer.
- Then ask exactly one next interview question.
- Keep tone conversational and professional.
- Return only plain text.

Conversation (recent):
$conversationText
      ''';

      final res = await Gemini.instance
          .text(promptForInterview)
          .timeout(const Duration(minutes: 5));

      final result = (res?.output ?? '').replaceAll('*', '').trim();
      if (result.isEmpty) {
        return _fallbackQuestion(topicModel, interviewModelMap);
      }

      log(interviewModelMap.toString(), name: 'Interview model');

      return result;
    } catch (e) {
      log('interview with ava again error repository: $e');
      return _fallbackQuestion(topicModel, interviewModelMap);
    }
  }

  String _fallbackQuestion(
    TopicModel topicModel,
    List<Map<String, dynamic>> interviewModelMap,
  ) {
    final List<String> subtopics =
        topicModel.subTopics.where((topic) => topic.trim().isNotEmpty).toList();

    if (subtopics.isNotEmpty) {
      final int index = interviewModelMap.length % subtopics.length;
      final String selected = subtopics[index];
      return 'Nice answer. Let us move to $selected. Can you explain it with one practical example?';
    }

    return 'Nice answer. Can you explain your thought process with one practical example?';
  }
}
