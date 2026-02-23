import 'package:flutter/material.dart';
import 'package:resume_ai/features/resume/model/analysed_resume_model.dart';

class NegativeImpactSentence extends StatelessWidget {
  final AnalysedResumeModel analysedResume;

  const NegativeImpactSentence({super.key, required this.analysedResume});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Negative Impact Sentence',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: analysedResume.negativeImpactSentences.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '❌ ${analysedResume.negativeImpactSentences[index]}',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
