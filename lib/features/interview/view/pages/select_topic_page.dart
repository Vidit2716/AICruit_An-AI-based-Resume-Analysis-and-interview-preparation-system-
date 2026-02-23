import 'package:flutter/material.dart';

import '../../model/topic_model.dart';
import '../widgets/topic_tile.dart';

class SelectTopicPage extends StatelessWidget {
  const SelectTopicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select topic'),
      ),
      body: ListView.builder(
        itemCount: TopicModel.topicsList.length,
        itemBuilder: (context, index) {
          final topic = TopicModel.topicsList[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TopicTile(topicModel: topic),
          );
        },
      ),
    );
  }
}
