import 'package:flutter/material.dart';
import 'package:resume_ai/features/resume/model/analysed_resume_model.dart';

class PositiveImpactSentence extends StatelessWidget {
  final AnalysedResumeModel analysedResume;

  const PositiveImpactSentence({super.key, required this.analysedResume});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 176, 224, 178),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Positive Impact Sentence',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: analysedResume.positiveImpactSentences.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '✅️ ${analysedResume.positiveImpactSentences[index]}',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
