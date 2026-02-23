import 'package:flutter/material.dart';

import '../custom_text_field.dart';

class Card1 extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController bioController;
  final TextEditingController expController;

  const Card1({
    super.key,
    required this.backgroundColor,
    required this.title,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.bioController,
    required this.expController,
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
              controller: firstNameController,
              title: 'First Name',
              hintText: 'eg. Sujal',
            ),
            CustomTextField(
              controller: lastNameController,
              title: 'Last Name',
              hintText: 'eg. Uttekar',
            ),
            CustomTextField(
              controller: bioController,
              title: 'Short Bio',
              maxLines: 2,
              hintText: 'eg. I am a Full Stack Web App Developer and ...',
              textInputAction: TextInputAction.none,
              keyboardType: TextInputType.multiline,
            ),
            CustomTextField(
              controller: expController,
              title: 'Years of Experience',
              hintText: 'eg. 2',
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
