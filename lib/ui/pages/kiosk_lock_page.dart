import 'package:flutter/material.dart';
import 'package:freecalls/domain/services/kiosk_services.dart';

class KioskLockPage extends StatelessWidget {
  const KioskLockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          icon: const Icon(Icons.close),
          iconSize: 50,
          color: Colors.white,
          onPressed: () {
            KioskMode.stopKioskMode();
          },
        ),
      ),
    );
  }
}
