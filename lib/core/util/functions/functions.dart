import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:order_delivery/core/util/lang/app_localizations.dart';

void showSnackBar(BuildContext context, Color color, String text,
    [int delay = 3]) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 3)));
}

void showConfirmDialog(BuildContext context, Function onConfirm) {
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      return AlertDialog(
        title:
            Text('Are You Sure?', style: Theme.of(context).textTheme.bodyLarge),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {
                onConfirm();
                Navigator.of(context).pop();
              },
              color: Colors.green,
              child: Text(
                "confirm",
                style: Theme.of(context).textTheme.bodySmall,
              )),
        ],
      );
    },
  );
}

void showCustomAboutDialog(BuildContext context, String title, String content,
    [List<Widget>? actions, bool barrierDismissible = true]) {
  showDialog(
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
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
                  color: Theme.of(context).colorScheme.onTertiary,
                  child: Text(
                    "ok".tr(context),
                    style: Theme.of(context).textTheme.labelSmall,
                  )),
            ],
      );
    },
  );
}

//for orders errors
void showToastMsg(BuildContext context, String msg, [bool done = false]) {
  // showToast(msg.tr(context),
  showToast(msg,
      backgroundColor: done ? Colors.green : Colors.red.shade800,
      borderRadius: BorderRadius.circular(20),
      textStyle: const TextStyle(
          fontSize: 17, fontWeight: FontWeight.w900, color: Colors.white),
      context: context,
      animation: StyledToastAnimation.slideFromTopFade,
      reverseAnimation: StyledToastAnimation.slideToTopFade,
      position:
          const StyledToastPosition(align: Alignment.topCenter, offset: 0.1),
      startOffset: const Offset(0.0, -3.0),
      reverseEndOffset: const Offset(0.0, -3.0),
      duration: const Duration(seconds: 4),
      //Animation duration   animDuration * 2 <= duration
      animDuration: const Duration(seconds: 1),
      curve: Curves.fastLinearToSlowEaseIn,
      reverseCurve: Curves.fastOutSlowIn);
}

void showToastMsgForProcess(BuildContext context, String msg) {
  // showToast(msg.tr(context),
  showToast(msg,
      backgroundColor: Colors.white38,
      borderRadius: BorderRadius.circular(20),
      textStyle: const TextStyle(
          fontSize: 17, fontWeight: FontWeight.w900, color: Colors.white),
      context: context,
      animation: StyledToastAnimation.slideFromBottomFade,
      reverseAnimation: StyledToastAnimation.slideToBottomFade,
      position:
          const StyledToastPosition(align: Alignment.bottomCenter, offset: 0.9),
      startOffset: const Offset(0.0, 4.0),
      reverseEndOffset: const Offset(0.0, 4.0),
      duration: const Duration(seconds: 5),
      //Animation duration   animDuration * 2 <= duration
      animDuration: const Duration(seconds: 1),
      curve: Curves.fastLinearToSlowEaseIn,
      reverseCurve: Curves.fastOutSlowIn);
}
