import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../model/analysed_resume_model.dart';
import '../pages/chatting_page.dart';
import '../pages/resume_insights_page.dart';

class AnalysedResumeTile extends StatelessWidget {
  final AnalysedResumeModel analysedResume;

  const AnalysedResumeTile({
    super.key,
    required this.analysedResume,
  });

  String getTimeDifference(Timestamp timestamp) {
    DateTime currentTime = DateTime.now();
    DateTime inputTime = timestamp.toDate();

    Duration difference = currentTime.difference(inputTime);

    if (difference.inMinutes < 1) {
      return "few moments ago";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minute(s) ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hour(s) ago";
    } else if (difference.inDays < 30) {
      return "${difference.inDays} day(s) ago";
    } else {
      int months = (difference.inDays / 30).floor();
      return "$months month(s) ago";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(12).copyWith(bottom: 2),
      decoration: BoxDecoration(
        color: Colors.white38,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  analysedResume.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                getTimeDifference(analysedResume.timestamp),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                'Overall Score: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${analysedResume.overallScore}/100',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Overall Feedback',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            analysedResume.overallFeedback,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChattingPage(
                          analysedResume: analysedResume,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 40,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade300,
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundImage: AssetImage('assets/images/ai.jpg'),
                          ),
                          SizedBox(width: 4),
                          Text('Chat'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ResumeInsightsPage(analysedResume: analysedResume),
                      ),
                    );
                  },
                  child: Container(
                    height: 40,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade300,
                    ),
                    child: const Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Report'),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios_rounded, size: 18),
                      ],
                    )),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
