import 'package:flutter/material.dart';
import 'package:resume_ai/features/resume/model/analysed_resume_model.dart';

class JobRoles extends StatelessWidget {
  final AnalysedResumeModel analysedResume;

  const JobRoles({super.key, required this.analysedResume});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Suited for jobs',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            children: analysedResume.jobRoles
                .map(
                  (jobRole) => Container(
                    padding: const EdgeInsets.all(6),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 4)
                            .copyWith(left: 0, right: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      jobRole,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
