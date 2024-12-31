import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, Color color, String text,
    [int delay = 3]) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: color,
      duration: Duration(seconds: 3)));
}

void showCustomAboutDialog(BuildContext context, String title, String content,
    [List<Widget>? actions, bool barrierDissmisable = true]) {
  showDialog(
    barrierDismissible: barrierDissmisable,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: Text(
          content,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        actions: actions ??
            [
              MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Theme.of(context).colorScheme.secondary,
                  child: Text(
                    "ok",
                    style: Theme.of(context).textTheme.bodySmall,
                  )),
            ],
      );
    },
  );
}
