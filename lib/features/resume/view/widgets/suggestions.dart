import 'package:flutter/material.dart';
import 'package:resume_ai/features/resume/model/analysed_resume_model.dart';

class Suggestions extends StatelessWidget {
  final AnalysedResumeModel analysedResume;

  const Suggestions({super.key, required this.analysedResume});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 239, 250, 213),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '💡Suggestions for Improvement',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: analysedResume.suggestionsForImprovement.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '${index + 1}. ${analysedResume.suggestionsForImprovement[index]}',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
