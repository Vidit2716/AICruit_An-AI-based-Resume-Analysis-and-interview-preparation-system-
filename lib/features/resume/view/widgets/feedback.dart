import 'package:flutter/material.dart';

import '../../model/analysed_resume_model.dart';

class OverallFeedback extends StatelessWidget {
  final AnalysedResumeModel analysedResume;

  const OverallFeedback({super.key, required this.analysedResume});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overall Feedback',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(analysedResume.overallFeedback),
        ],
      ),
    );
  }
}
