import 'analysed_resume_model.dart';

enum ChatRole { user, assistant, system }

class ChatModel {
  final String message;
  final ChatRole role;
  final int createdAtMs;

  // Context to keep each message tied to the analysed resume.
  final String resumeId;
  final String resumeName;
  final Map<String, dynamic> resumeContext;

  bool get isMe => role == ChatRole.user;

  const ChatModel({
    required this.message,
    required this.role,
    required this.createdAtMs,
    this.resumeId = '',
    this.resumeName = '',
    this.resumeContext = const <String, dynamic>{},
  });

  factory ChatModel.legacy({
    required String message,
    required bool isMe,
  }) {
    return ChatModel(
      message: message,
      role: isMe ? ChatRole.user : ChatRole.assistant,
      createdAtMs: DateTime.now().millisecondsSinceEpoch,
    );
  }

  factory ChatModel.user({
    required String message,
    required AnalysedResumeModel analysedResume,
  }) {
    return ChatModel(
      message: message,
      role: ChatRole.user,
      createdAtMs: DateTime.now().millisecondsSinceEpoch,
      resumeId: analysedResume.id,
      resumeName: analysedResume.name,
      resumeContext: _compactResumeContext(analysedResume),
    );
  }

  factory ChatModel.assistant({
    required String message,
    required AnalysedResumeModel analysedResume,
  }) {
    return ChatModel(
      message: message,
      role: ChatRole.assistant,
      createdAtMs: DateTime.now().millisecondsSinceEpoch,
      resumeId: analysedResume.id,
      resumeName: analysedResume.name,
      resumeContext: _compactResumeContext(analysedResume),
    );
  }

  factory ChatModel.system({
    required String message,
    required AnalysedResumeModel analysedResume,
  }) {
    return ChatModel(
      message: message,
      role: ChatRole.system,
      createdAtMs: DateTime.now().millisecondsSinceEpoch,
      resumeId: analysedResume.id,
      resumeName: analysedResume.name,
      resumeContext: _compactResumeContext(analysedResume),
    );
  }

  static Map<String, dynamic> _compactResumeContext(
      AnalysedResumeModel analysedResume) {
    return <String, dynamic>{
      'id': analysedResume.id,
      'name': analysedResume.name,
      'overallScore': analysedResume.overallScore,
      'grammarScore': analysedResume.grammarScore,
      'contentScore': analysedResume.contentScore,
      'clarityScore': analysedResume.clarityScore,
      'readabilityScore': analysedResume.readabilityScore,
      'jobRoles': analysedResume.jobRoles,
      'suggestionsForImprovement': analysedResume.suggestionsForImprovement,
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'role': role.name,
      'createdAtMs': createdAtMs,
      'resumeId': resumeId,
      'resumeName': resumeName,
      'resumeContext': resumeContext,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    final roleValue = map['role']?.toString() ?? ChatRole.assistant.name;
    final parsedRole = ChatRole.values.firstWhere(
      (value) => value.name == roleValue,
      orElse: () => ChatRole.assistant,
    );

    return ChatModel(
      message: map['message']?.toString() ?? '',
      role: parsedRole,
      createdAtMs: (map['createdAtMs'] as num?)?.toInt() ??
          DateTime.now().millisecondsSinceEpoch,
      resumeId: map['resumeId']?.toString() ?? '',
      resumeName: map['resumeName']?.toString() ?? '',
      resumeContext:
          Map<String, dynamic>.from(map['resumeContext'] as Map? ?? {}),
    );
  }
}
