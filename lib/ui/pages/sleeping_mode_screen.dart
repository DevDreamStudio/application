import 'package:flutter/material.dart';
import 'package:freecalls/ui/pages/select_language_page.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class SleepingModeScreen extends StatelessWidget {
  const SleepingModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SelectLanguagePage()),
      );
    });
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SelectLanguagePage(),
          ),
        );
      },
      child: Scaffold(
        body: Center(
          child: ZoomTapAnimation(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SelectLanguagePage(),
                ),
              );
            },
            child: Image.asset(
              'assets/images/call.png',
              width: 500,
            ),
          ),
        ),
      ),
    );
  }
}
