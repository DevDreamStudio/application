import 'package:flutter/material.dart';
import 'package:freecalls/ui/pages/kiosk_lock_page.dart';
import 'package:freecalls/ui/pages/select_language_page.dart';
import 'package:pin_code_view/pin_code_view.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PinCode(
        backgroundColor: const Color(0xff0b0d17),
        title: 'Введите код',
        onChange: (pin) {
          if (pin == '020311') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const KioskLockPage(),
              ),
            );
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SelectLanguagePage(),
              ),
            );
          }
        },
      ),
    );
  }
}
