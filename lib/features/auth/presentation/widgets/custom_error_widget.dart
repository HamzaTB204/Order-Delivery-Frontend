import 'package:flutter/material.dart';
import 'package:order_delivery/core/util/lang/app_localizations.dart';

class CustomErrorWidget extends StatelessWidget {
  final String msg;

  const CustomErrorWidget({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "$msg \n\n${"retry".tr(context)}",
        style: const TextStyle(
            fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
      ),
    );
  }
}
