import 'package:flutter/material.dart';

import '../widgets/custom_button.dart';
import './your_resumes_page.dart';
import './analyse_resume_page.dart';

class ResumePage extends StatelessWidget {
  const ResumePage({super.key});

  @override
  Widget build(BuildContext context) {
    final devicewidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Analyse Resume with AI',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const Text(
                  'Receive in-depth resume feedback and interact with our chatbot to make necessary corrections',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage('assets/images/ai.jpg'),
                  foregroundImage: AssetImage('assets/images/ai.jpg'),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: devicewidth * 0.23),
                  child: const Text(
                    "I am Ava, I'll help you with your resume...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  title: '🚀 Let\'s Begin',
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(AnalyseResumePage.routeName);
                  },
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(YourResumesPage.routeName);
                  },
                  child: const Text('View Analysed Resumes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
