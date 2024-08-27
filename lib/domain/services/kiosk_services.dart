import 'package:flutter/services.dart';

class KioskMode {
  static const platform = MethodChannel('kioskModeLocked');

  static startKioskMode() async {
    await platform.invokeMethod('startKioskMode');
  }

  static stopKioskMode() async {
    await platform.invokeMethod('stopKioskMode');
  }
}
