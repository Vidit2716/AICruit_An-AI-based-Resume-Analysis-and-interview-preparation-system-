import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resume_ai/features/interview/view/pages/interview_page.dart';

import '../../model/topic_model.dart';
import '../../viewmodel/interview_viewmodel.dart';

class InterviewInfoPage extends StatelessWidget {
  final TopicModel topicModel;

  const InterviewInfoPage({super.key, required this.topicModel});

  @override
  Widget build(BuildContext context) {
    final interviewViewModel = Provider.of<InterviewViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interview Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: Image(
                  image: AssetImage(topicModel.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                topicModel.topicName,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Wrap(
                children: topicModel.subTopics.map((subTopic) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(right: 8, bottom: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.purple.shade100,
                    ),
                    child: Text(
                      subTopic,
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text(
                'Interview difficulty',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () =>
                        interviewViewModel.setInterviewDifficulty('Easy'),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.green.shade100,
                        border: Border.all(
                          color:
                              interviewViewModel.interviewDifficulty == 'Easy'
                                  ? Colors.green
                                  : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: const Text(
                        'Easy',
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                        interviewViewModel.setInterviewDifficulty('Medium'),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.orange.shade100,
                        border: Border.all(
                          color:
                              interviewViewModel.interviewDifficulty == 'Medium'
                                  ? Colors.orange
                                  : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: const Text(
                        'Medium',
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                        interviewViewModel.setInterviewDifficulty('Hard'),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.red.shade100,
                        border: Border.all(
                          color:
                              interviewViewModel.interviewDifficulty == 'Hard'
                                  ? Colors.red
                                  : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: const Text(
                        'Hard',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => InterviewPage(topicModel: topicModel),
                  ),
                ),
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.black),
                ),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Take Interview',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
