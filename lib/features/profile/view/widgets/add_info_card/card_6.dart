import 'package:flutter/material.dart';

import '../custom_text_field.dart';

class Card6 extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String title;
  final Color backgroundColor;
  final TextEditingController portfolioController;
  final TextEditingController linkedInController;
  final TextEditingController githubController;
  final TextEditingController otherController;

  const Card6({
    super.key,
    required this.formKey,
    required this.title,
    required this.backgroundColor,
    required this.portfolioController,
    required this.linkedInController,
    required this.githubController,
    required this.otherController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: backgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: portfolioController,
              title: 'Portfolio Link',
              hintText: 'eg. https://www.portfolio.com/...',
            ),
            CustomTextField(
              controller: linkedInController,
              title: 'LinkedIn',
              hintText: 'eg. https://linkedin.com/...',
            ),
            CustomTextField(
              controller: githubController,
              title: 'Github',
              hintText: 'eg. https://github.com/...',
              textInputAction: TextInputAction.none,
              keyboardType: TextInputType.multiline,
            ),
            CustomTextField(
              controller: otherController,
              title: 'Other',
              hintText: 'eg. https://other.com/...',
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              maxLength: 2,
            ),
          ],
        ),
      ),
    );
  }
}
