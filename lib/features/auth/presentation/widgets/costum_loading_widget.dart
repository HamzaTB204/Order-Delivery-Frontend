import 'package:flutter/material.dart';

class CustomLoadingWidget extends StatefulWidget {
  const CustomLoadingWidget({super.key});

  @override
  State<CustomLoadingWidget> createState() {
    return _LoadingWidget();
  }
}

class _LoadingWidget extends State<CustomLoadingWidget> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: 0.2 * height,
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.greenAccent,
        ),
      ),
    );
  }
}
