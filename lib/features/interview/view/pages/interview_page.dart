import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:resume_ai/core/utils.dart';

import '../../../../core/common/provider/current_usermodel.dart';
import '../../model/topic_model.dart';
import '../../viewmodel/interview_viewmodel.dart';

class InterviewPage extends StatefulWidget {
  final TopicModel topicModel;

  const InterviewPage({super.key, required this.topicModel});

  @override
  State<InterviewPage> createState() => _InterviewPageState();
}

class _InterviewPageState extends State<InterviewPage> {
  final SpeechToText _speechToText = SpeechToText();
  String _lastWords = '';
  bool _isSubmittingAnswer = false;
  bool _isSessionInitializing = true;
  bool _speechInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeInterview();
  }

  Future<void> _initializeInterview() async {
    await _initSpeech();
    if (!mounted) return;

    final userModel = Provider.of<CurrentUserModel>(context, listen: false);
    final interviewViewModel =
        Provider.of<InterviewViewModel>(context, listen: false);

    final shouldSpeakIntro = await interviewViewModel.startInterviewSession(
      topicModel: widget.topicModel,
      userName: userModel.user?.name ?? '',
    );
    if (!mounted) return;

    setState(() {
      _isSessionInitializing = false;
    });

    if (shouldSpeakIntro &&
        (interviewViewModel.avaResponse ?? '').trim().isNotEmpty) {
      await interviewViewModel.avaSpeaks(interviewViewModel.avaResponse!);
    }
  }

  Future<void> _initSpeech() async {
    _speechInitialized = await _speechToText.initialize(
      onStatus: (status) async {
        if (status == 'done' || status == 'notListening') {
          await _submitIfReady(showErrorOnEmpty: false);
        }
      },
    );
  }

  Future<void> _startListening() async {
    if (!_speechInitialized) {
      showSnackBar(context, 'Microphone is not initialized yet.');
      return;
    }

    final interviewViewModel =
        Provider.of<InterviewViewModel>(context, listen: false);
    if (interviewViewModel.isAvaSpeaking ||
        interviewViewModel.isAvaReplying ||
        _isSessionInitializing) {
      return;
    }

    try {
      setState(() {
        _lastWords = '';
      });

      await _speechToText.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(seconds: 30),
        listenOptions: SpeechListenOptions(
          cancelOnError: false,
          partialResults: false,
          listenMode: ListenMode.search,
        ),
      );
    } catch (e) {
      print(e.toString());
    }

    if (!mounted) return;
    setState(() {});
  }

  Future<void> _stopListening() async {
    await _speechToText.stop();
    if (!mounted) return;
    setState(() {});
    await _submitIfReady(showErrorOnEmpty: true);
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });

    if (result.finalResult) {
      _submitIfReady(showErrorOnEmpty: false);
    }
  }

  Future<void> _submitIfReady({required bool showErrorOnEmpty}) async {
    if (_isSubmittingAnswer) return;
    final message = _lastWords.trim();
    if (message.isEmpty) {
      if (showErrorOnEmpty && mounted) {
        showSnackBar(context, 'Could not catch your answer. Please try again.');
      }
      return;
    }

    _isSubmittingAnswer = true;
    try {
      await submitAnswerToAva(message);
      if (!mounted) return;
      setState(() {
        _lastWords = '';
      });
    } finally {
      _isSubmittingAnswer = false;
    }
  }

  Future<void> submitAnswerToAva(String message) async {
    final interviewViewModel =
        Provider.of<InterviewViewModel>(context, listen: false);

    List<Map<String, dynamic>> interviewModelMap = [
      {
        'message': message.trim(),
        'isUser': true,
      }
    ];

    await interviewViewModel.setInterviewModelMap(interviewModelMap);

    await interviewViewModel.interviewWithAva(
      interviewViewModel.interviewModelMap,
      interviewViewModel.interviewDifficulty,
      widget.topicModel,
    );
  }

  void _showConversationSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      builder: (context) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: Consumer<InterviewViewModel>(
              builder: (context, value, child) {
                final messages = value.interviewModelMap;
                if (messages.isEmpty) {
                  return const Center(
                    child: Text(
                      'No conversation yet.',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final item = messages[index];
                    final isUser = item['isUser'] == true;
                    final message = item['message']?.toString() ?? '';

                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(10),
                        constraints: const BoxConstraints(maxWidth: 280),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.blueGrey : Colors.white10,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isUser ? 'You' : 'Ava',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              message,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _startFreshConversation() async {
    final interviewViewModel =
        Provider.of<InterviewViewModel>(context, listen: false);
    final userModel = Provider.of<CurrentUserModel>(context, listen: false);

    if (interviewViewModel.isAvaReplying ||
        interviewViewModel.isAvaSpeaking ||
        interviewViewModel.isPreparingSession) {
      return;
    }

    final bool? shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Start Fresh Interview'),
          content: const Text(
            'This will clear the previous conversation for this topic and difficulty. Continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Start Fresh'),
            ),
          ],
        );
      },
    );

    if (shouldReset != true) return;

    await _speechToText.stop();
    if (!mounted) return;

    final shouldSpeakIntro = await interviewViewModel.clearAndStartFreshSession(
      topicModel: widget.topicModel,
      userName: userModel.user?.name ?? '',
    );

    if (!mounted) return;
    setState(() {
      _lastWords = '';
    });

    if (shouldSpeakIntro &&
        (interviewViewModel.avaResponse ?? '').trim().isNotEmpty) {
      await interviewViewModel.avaSpeaks(interviewViewModel.avaResponse!);
    }
  }

  @override
  void dispose() {
    _speechToText.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final interviewViewModel = Provider.of<InterviewViewModel>(context);
    final userModel = Provider.of<CurrentUserModel>(context);
    final introFallback =
        "Hey ${userModel.user?.name ?? 'there'},\nMy name is Ava. I'll be taking your mock interview on ${widget.topicModel.topicName}. Can you start by introducing yourself?";
    final displayMessage =
        (interviewViewModel.avaResponse ?? '').trim().isNotEmpty
            ? interviewViewModel.avaResponse!
            : introFallback;

    return PopScope(
      onPopInvoked: (didPop) async {
        if (!didPop) return;
        await _speechToText.stop();
        await interviewViewModel.avaStop();
        interviewViewModel.setAvaResponseToNull();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              onPressed: _startFreshConversation,
              icon: const Icon(Icons.refresh),
              tooltip: 'Clear and start fresh',
            ),
            IconButton(
              onPressed: _showConversationSheet,
              icon: const Icon(Icons.chat_bubble_outline),
              tooltip: 'View conversation',
            ),
          ],
        ),
        body: (_isSessionInitializing || interviewViewModel.isPreparingSession)
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 110,
                          backgroundImage: AssetImage('assets/images/ai.jpg'),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          displayMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 50),
                        _speechToText.isListening
                            ? const Text(
                                'Ava is listening',
                                style: TextStyle(color: Colors.white),
                              )
                            : const SizedBox.shrink(),
                        _speechToText.isListening
                            ? const SizedBox(height: 16)
                            : const SizedBox.shrink(),
                        interviewViewModel.isAvaReplying
                            ? const Padding(
                                padding: EdgeInsets.only(bottom: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Ava is replying...',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(),
                        Consumer<InterviewViewModel>(
                          builder: (context, value, child) {
                            return (value.isAvaSpeaking ||
                                    value.isAvaReplying ||
                                    _isSessionInitializing)
                                ? ElevatedButton(
                                    onPressed: null,
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                        Colors.red.shade600,
                                      ),
                                      foregroundColor:
                                          const WidgetStatePropertyAll(
                                        Colors.white,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          value.isAvaReplying
                                              ? 'Ava is replying'
                                              : 'Ava is speaking',
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(
                                          _speechToText.isNotListening
                                              ? Icons.mic_off
                                              : Icons.mic,
                                        ),
                                      ],
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: () async {
                                      _speechToText.isNotListening
                                          ? await _startListening()
                                          : await _stopListening();
                                    },
                                    style: const ButtonStyle(
                                      foregroundColor: WidgetStatePropertyAll(
                                        Colors.black,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text('Answer here'),
                                        const SizedBox(width: 4),
                                        Icon(
                                          _speechToText.isNotListening
                                              ? Icons.mic_off
                                              : Icons.mic,
                                        ),
                                      ],
                                    ),
                                  );
                          },
                        ),
                        const SizedBox(height: 50),
                        _lastWords.isNotEmpty
                            ? const Text(
                                'Your response:',
                                style: TextStyle(color: Colors.white),
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(height: 4),
                        Text(
                          _lastWords.isNotEmpty
                              ? _lastWords
                              : 'Tap the microphone to give answer...',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
