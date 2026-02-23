import 'package:flutter/material.dart';

bool isNumber(String s) {
  return double.tryParse(s) != null;
}

showSnackBar(BuildContext context, String message, {int duration = 4}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: Duration(seconds: duration),
        content: Text(message),
      ),
    );
}

showDialogBox(
  BuildContext context, {
  required String title,
  required String content,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: onConfirm,
            child: const Text('Confirm'),
          ),
        ],
      );
    },
  );
}
