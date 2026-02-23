import 'package:flutter/material.dart';

import '../custom_text_field.dart';

class Card2 extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  const Card2({
    super.key,
    required this.backgroundColor,
    required this.title,
    required this.formKey,
    required this.emailController,
    required this.phoneController,
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
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: emailController,
              title: 'Email',
              hintText: 'eg. sujalisosm@gmail.com',
              keyboardType: TextInputType.emailAddress,
            ),
            CustomTextField(
              controller: phoneController,
              title: 'Phone',
              hintText: 'eg. 8698623998',
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              maxLength: 10,
            ),
          ],
        ),
      ),
    );
  }
}
