import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils.dart';
import '../../model/analysed_resume_model.dart';
import '../../model/chat_model.dart';
import '../widgets/chat_message.dart';
import '../widgets/custom_text_field.dart';
import '../../viewmodel/resume_viewmodel.dart';

class ChattingPage extends StatefulWidget {
  final AnalysedResumeModel analysedResume;

  const ChattingPage({super.key, required this.analysedResume});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  final TextEditingController controller = TextEditingController();
  final List<ChatModel> _chatMessages = [];
  bool _isReplying = false;
  bool _isBootstrapping = true;

  @override
  void initState() {
    super.initState();
    _loadSavedMessages();
  }

  Future<void> _loadSavedMessages() async {
    final resumeViewModel =
        Provider.of<ResumeViewmodel>(context, listen: false);
    final messages =
        await resumeViewModel.getChatMessages(widget.analysedResume.id);

    if (!mounted) return;
    setState(() {
      _chatMessages
        ..clear()
        ..addAll(messages);
      if (_chatMessages.isEmpty) {
        _chatMessages.add(
          ChatModel.system(
            message: 'How can I help you?',
            analysedResume: widget.analysedResume,
          ),
        );
      }
      _isBootstrapping = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void chattingWithAva(String promptByUser) async {
    final resumeViewModel =
        Provider.of<ResumeViewmodel>(context, listen: false);
    final userMessage = ChatModel.user(
      message: promptByUser,
      analysedResume: widget.analysedResume,
    );

    setState(() {
      _isReplying = true;
      _chatMessages.add(userMessage);
    });

    await resumeViewModel.saveChatMessage(userMessage);

    try {
      String aiMessage = await resumeViewModel.chattingWithAva(
          widget.analysedResume, promptByUser);

      final assistantMessage = ChatModel.assistant(
        message: aiMessage.isEmpty ? 'Could not generate a reply.' : aiMessage,
        analysedResume: widget.analysedResume,
      );

      if (!mounted) return;
      setState(() {
        _chatMessages.add(assistantMessage);
      });
      await resumeViewModel.saveChatMessage(assistantMessage);
    } finally {
      if (!mounted) return;
      setState(() {
        _isReplying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final resumeViewModel = Provider.of<ResumeViewmodel>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/ai.jpg'),
            ),
            SizedBox(width: 8),
            Text('Ava'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: _isBootstrapping
                  ? const Center(
                      child: SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          ..._chatMessages
                              .map((chat) => ChatMessage(chatModel: chat))
                              .toList(),
                          if (_isReplying)
                            const Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundImage:
                                        AssetImage('assets/images/ai.jpg'),
                                  ),
                                  SizedBox(width: 8),
                                  SizedBox(
                                    height: 16,
                                    width: 16,
                                    child:
                                        CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                  SizedBox(width: 10),
                                  Text('Ava is replying...'),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
            ),
            buildTextField(
              controller: controller,
              isLoading: _isReplying,
              onTap: () {
                try {
                  if (_isReplying) {
                    return;
                  }
                  if (controller.text.isEmpty ||
                      controller.text.trim().isEmpty) {
                    showSnackBar(context, 'Please enter a message',
                        duration: 2);
                    return;
                  }

                  chattingWithAva(controller.text.trim());

                  controller.clear();

                  FocusScope.of(context).unfocus();
                } catch (e) {
                  showSnackBar(context, 'Error: $e', duration: 2);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildTextField({
  required TextEditingController controller,
  required bool isLoading,
  required VoidCallback onTap,
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 12),
    child: Row(
      children: [
        Expanded(
          child: CustomTextField(controller: controller),
        ),
        GestureDetector(
          onTap: isLoading ? null : onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: const EdgeInsets.only(bottom: 12),
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isLoading ? Colors.grey.shade500 : Colors.blue.shade600,
            ),
            child: Icon(
              isLoading ? Icons.hourglass_top : Icons.send,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}
