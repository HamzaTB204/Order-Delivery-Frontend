import 'package:flutter/material.dart';
import 'package:order_delivery/main.dart';

class CustomSplashScreen extends StatefulWidget {
  final bool navigate;

  const CustomSplashScreen({super.key, required this.navigate});

  @override
  State<CustomSplashScreen> createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.navigate) _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MyApp()), (r) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Image.asset(
          'assets/splash/splash.jpg',
          fit: BoxFit.cover,
          height: height,
          width: width,
        ),
        Positioned(
            left: 0.45 * width,
            bottom: 0.1 * height,
            child: const CircularProgressIndicator(
              strokeWidth: 7,
              strokeAlign: 2,
              color: Colors.lightGreenAccent,
            ))
      ],
    );
  }
}
