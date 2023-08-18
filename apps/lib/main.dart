import 'package:apps/ui/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:resources/resources.dart';


Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localeResolutionCallback: (Locale? locale, Iterable<Locale> supportedLocales) =>
      supportedLocales.contains(locale)
          ? locale
          : const Locale("en"),
      locale: Locale("en"),
      supportedLocales: S.delegate.supportedLocales,
      title: 'My app',
      home: HomePage(),
    );
  }
}
