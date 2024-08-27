import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:freecalls/ui/pages/home_page.dart';
import 'package:freecalls/ui/pages/mounted_page.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class SelectLanguagePage extends StatefulWidget {
  const SelectLanguagePage({super.key});

  @override
  State<SelectLanguagePage> createState() => _SelectLanguagePageState();
}

class _SelectLanguagePageState extends State<SelectLanguagePage> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    const inactivityDuration = Duration(seconds: 100);
    _timer = Timer(inactivityDuration, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MountedPage()),
      );
    });
  }

  void _resetTimer() {
    _timer.cancel();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    List<Map<String, dynamic>> languagesItems = [
      {'flag': FlagsCode.UZ, "title": 'O\'zbek', "code": 'uz'},
      {'flag': FlagsCode.RU, "title": 'Русский', "code": 'ru'},
      {'flag': FlagsCode.US, "title": 'English', "code": 'en'},
    ];
    List<Widget> items = List.generate(languagesItems.length, (index) {
      return ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        child: ZoomTapAnimation(
          onTap: () {
            _resetTimer();
            context.setLocale(Locale(languagesItems[index]['code'])).then(
                  (value) => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  ),
                );
          },
          child: SizedBox(
            width: 220,
            height: 180,
            child: Flag.fromCode(
              languagesItems[index]['flag'],
              fit: BoxFit.cover,
              borderRadius: 10,
            ),
          ),
        ),
      );
    });
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        _resetTimer();
        return false;
      },
      child: GestureDetector(
        onTap: () {
          _resetTimer();
        },
        child: Scaffold(
          body: Center(
            child: Ink(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              height: _size.height * .8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 80,
                    child: AnimatedTextKit(
                      repeatForever: true,
                      pause: const Duration(milliseconds: 400),
                      animatedTexts: [
                        RotateAnimatedText(
                          'Выберите язык',
                          duration: const Duration(seconds: 3),
                          textStyle: const TextStyle(
                            fontSize: 52,
                            color: Colors.white,
                          ),
                        ),
                        RotateAnimatedText(
                          'Choose a language',
                          duration: const Duration(seconds: 3),
                          textStyle: const TextStyle(
                            fontSize: 52,
                            color: Colors.white,
                          ),
                        ),
                        RotateAnimatedText(
                          'Til tanlang',
                          duration: const Duration(seconds: 3),
                          textStyle: const TextStyle(
                            fontSize: 52,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: items,
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
