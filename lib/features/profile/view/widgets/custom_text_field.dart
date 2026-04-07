import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String hintText;
  final int maxLines;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final int? maxLength;
  // final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.title,
    required this.hintText,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    // this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),
          TextFormField(
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            onFieldSubmitted: (_) {
              if (textInputAction == TextInputAction.next) {
                FocusScope.of(context).nextFocus();
                return;
              }
              if (textInputAction == TextInputAction.done) {
                FocusScope.of(context).unfocus();
              }
            },
            maxLines: maxLines,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $title';
              }
              return null;
            },
            // validator: null,
            // onChanged: onChanged,
            textInputAction: textInputAction,
            keyboardType: keyboardType,
            maxLength: maxLength,
            controller: controller,
            decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(12),
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.grey),
              fillColor: Colors.white,
              filled: true,
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.purple,
                ),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.purple,
                ),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
