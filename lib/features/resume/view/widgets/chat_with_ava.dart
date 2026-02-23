import 'package:flutter/material.dart';

import '../../model/analysed_resume_model.dart';
import '../pages/chatting_page.dart';

class ChatWithAva extends StatelessWidget {
  final AnalysedResumeModel analysedResume;

  const ChatWithAva({super.key, required this.analysedResume});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 211, 203, 187),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chat with Ava!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ava is your personal AI assistant who can help you improve your resume.\nAsk her anything!',
                  style: TextStyle(color: Colors.grey.shade800),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ChattingPage(analysedResume: analysedResume),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                  ),
                  child: const Text(
                    'Chat Now',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const CircleAvatar(
            radius: 70,
            backgroundImage: AssetImage('assets/images/ai.jpg'),
          ),
        ],
      ),
    );
  }
}
