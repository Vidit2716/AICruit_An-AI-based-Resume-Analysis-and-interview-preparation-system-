import 'package:flutter/material.dart';

import '../../model/analysed_resume_model.dart';
import '../widgets/chat_with_ava.dart';
import '../widgets/feedback.dart';
import '../widgets/general_feedback.dart';
import '../widgets/job_roles.dart';
import '../widgets/negative_impact_sentence.dart';
import '../widgets/positive_impact_sentence.dart';
import '../widgets/score_tile.dart';
import '../widgets/suggestions.dart';

class ResumeInsightsPage extends StatelessWidget {
  static const String routeName = '/resume-insights';
  final AnalysedResumeModel analysedResume;

  const ResumeInsightsPage({
    super.key,
    required this.analysedResume,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Insights'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChatWithAva(analysedResume: analysedResume),
              const SizedBox(height: 16),
              OverallFeedback(analysedResume: analysedResume),
              const SizedBox(height: 16),
              ScoreTile(analysedResume: analysedResume),
              const SizedBox(height: 16),
              PositiveImpactSentence(analysedResume: analysedResume),
              const SizedBox(height: 16),
              NegativeImpactSentence(analysedResume: analysedResume),
              const SizedBox(height: 16),
              JobRoles(analysedResume: analysedResume),
              const SizedBox(height: 16),
              GeneralFeedback(analysedResume: analysedResume),
              const SizedBox(height: 16),
              Suggestions(analysedResume: analysedResume),
            ],
          ),
        ),
      ),
    );
  }
}
