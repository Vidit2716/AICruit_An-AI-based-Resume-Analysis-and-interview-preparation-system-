import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/provider/current_usermodel.dart';
import '../../model/chat_model.dart';

class ChatMessage extends StatelessWidget {
  final ChatModel chatModel;

  const ChatMessage({super.key, required this.chatModel});

  @override
  Widget build(BuildContext context) {
    final currentUserModel = Provider.of<CurrentUserModel>(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            chatModel.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!chatModel.isMe)
            const CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/images/ai.jpg'),
            ),
          if (!chatModel.isMe) const SizedBox(width: 8),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.62,
              minWidth: MediaQuery.of(context).size.width * 0.15,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade300,
            ),
            child: Text(
              chatModel.message,
              textAlign: chatModel.isMe ? TextAlign.right : TextAlign.left,
            ),
          ),
          if (chatModel.isMe) const SizedBox(width: 8),
          if (chatModel.isMe)
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(currentUserModel.user!.photoUrl),
            ),
        ],
      ),
    );
  }
}
