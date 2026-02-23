import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../model/analysed_resume_model.dart';

double _scorePercentFromString(String s) {
  final cleaned = s.replaceAll('%', '').trim();
  final d = double.tryParse(cleaned);
  if (d == null) return 0.01; // fallback small percent
  final clamped = d.clamp(0, 100);
  return clamped / 100;
}

String _displayScore(String s) {
  final cleaned = s.replaceAll('%', '').trim();
  final d = double.tryParse(cleaned);
  if (d == null) return 'N/A';
  return '${d.round()}/100';
}

class ScoreTile extends StatelessWidget {
  final AnalysedResumeModel analysedResume;

  const ScoreTile({super.key, required this.analysedResume});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: buildScoreTile(
                title: 'Overall Score',
                score: analysedResume.overallScore,
                color: const Color.fromARGB(255, 221, 224, 172),
                progessColor: const Color.fromARGB(255, 175, 175, 102),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: buildScoreTile(
                title: 'Grammar Score',
                score: analysedResume.grammarScore,
                color: Colors.green.shade100,
                progessColor: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: buildScoreTile(
                title: 'Content Score',
                score: analysedResume.contentScore,
                color: const Color.fromARGB(255, 166, 207, 241),
                progessColor: Colors.blue,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: buildScoreTile(
                title: 'Clarity Score',
                score: analysedResume.clarityScore,
                color: const Color.fromARGB(255, 228, 199, 233),
                progessColor: Colors.purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 243, 196, 196),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Readability Score',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    CircularPercentIndicator(
                      radius: 40,
                      percent: _scorePercentFromString(analysedResume.readabilityScore),
                      progressColor: Colors.red.shade300,
                      animation: true,
                      animationDuration: 2000,
                      center: Text(
                        _displayScore(analysedResume.readabilityScore),
                        style: const TextStyle(fontSize: 16),
                      ),
                      lineWidth: 7,
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Widget buildScoreTile(
    {required String title,
    required String score,
    required Color color,
    required Color progessColor}) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        CircularPercentIndicator(
          radius: 40,
          percent: _scorePercentFromString(score),
          progressColor: progessColor,
          animation: true,
          animationDuration: 2000,
          center: Text(
            _displayScore(score),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          lineWidth: 7,
          circularStrokeCap: CircularStrokeCap.round,
        ),
      ],
    ),
  );
}
