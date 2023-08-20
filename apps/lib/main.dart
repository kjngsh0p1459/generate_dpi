import 'package:apps/ui/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:resources/resources.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppDimen.of(context);
    AppColors.of(context);
    return ScreenUtilInit(
      designSize: const Size(DeviceConstants.designDeviceWidth,
          DeviceConstants.designDeviceHeight),
      builder: (context, state) {
        return MaterialApp(
          localeResolutionCallback:
              (Locale? locale, Iterable<Locale> supportedLocales) =>
                  supportedLocales.contains(locale)
                      ? locale
                      : const Locale(LocaleConstants.defaultLocale),
          locale: Locale(LocaleConstants.defaultLocale),
          supportedLocales: S.delegate.supportedLocales,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: HomePage(),
        );
      },
    );
  }
}

class LocaleConstants {
  const LocaleConstants._();

  static const en = 'en';
  static const ja = 'ja';
  static const defaultLocale = 'en';
}
