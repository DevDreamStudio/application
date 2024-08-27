import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freecalls/domain/services/kiosk_services.dart';
import 'package:freecalls/ui/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KioskMode.startKioskMode();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const <Locale>[
        Locale('ru'),
        Locale('uz'),
        Locale('en'),
      ],
      path: 'assets/translations',
      useOnlyLangCode: true,
      saveLocale: true,
      child: const MyApp(),
    ),
  );
}
