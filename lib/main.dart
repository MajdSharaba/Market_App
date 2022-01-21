//@dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_app/constants.dart';
import 'package:market_app/pages/auth/loginPage.dart';
import 'package:market_app/pages/home.dart';
import 'package:market_app/pages/store.dart';
import 'package:market_app/pages/lockApp.dart';
import 'package:market_app/pages/watch_details.dart';
import 'package:market_app/translate/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: () => MaterialApp(
        locale: _locale,
        supportedLocales: [
          Locale("en", "US"),
          Locale("ar", "SA"),
        ],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        home:
        // Login(),
        // AppLock(),
        Home(),
        debugShowCheckedModeBanner: false,
        title: 'Osme',
        theme: ThemeData(
          fontFamily: 'pac',
          primarySwatch: Constants().createMaterialColor(Color.fromRGBO(224, 177, 121, 1)),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          // textTheme: GoogleFonts.latoTextTheme(
          //   TextTheme(),
          // ),
        ),
      ),
    );
  }
}

