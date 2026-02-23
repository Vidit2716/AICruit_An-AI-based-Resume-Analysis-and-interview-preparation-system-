import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;

  const CustomTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          hintText: 'Ask her anything...',
          hintStyle: TextStyle(color: Colors.grey.shade600),
          fillColor: Colors.grey.shade300,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
