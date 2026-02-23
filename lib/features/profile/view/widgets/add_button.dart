import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class AddButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const AddButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(16),
      dashPattern: const [10, 2],
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(4),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
