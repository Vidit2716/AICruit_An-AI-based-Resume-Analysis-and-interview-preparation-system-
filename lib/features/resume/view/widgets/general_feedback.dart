import 'package:flutter/material.dart';
import 'package:resume_ai/features/resume/model/analysed_resume_model.dart';

class GeneralFeedback extends StatelessWidget {
  final AnalysedResumeModel analysedResume;

  const GeneralFeedback({super.key, required this.analysedResume});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📝 General Feedback',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: analysedResume.generalFeedback.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '${index + 1}. ${analysedResume.generalFeedback[index]}',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
