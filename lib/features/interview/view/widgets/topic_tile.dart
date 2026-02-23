import 'package:flutter/material.dart';

import '../../model/topic_model.dart';
import '../pages/interview_info_page.dart';

class TopicTile extends StatelessWidget {
  final TopicModel topicModel;

  const TopicTile({super.key, required this.topicModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => InterviewInfoPage(topicModel: topicModel),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade300,
          // border: Border.all(color: Colors.grey.shade300),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: Image(
                image: AssetImage(topicModel.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                topicModel.topicName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
