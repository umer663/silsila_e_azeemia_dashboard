import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:silsila_e_azeemia_dashboard/screens/public/about_us/about_us_screen.dart';
import 'package:silsila_e_azeemia_dashboard/screens/public/books/books_screen.dart';
import 'package:silsila_e_azeemia_dashboard/screens/public/contact_us/contact_us_screen.dart';
import 'package:silsila_e_azeemia_dashboard/screens/public/digests/digests_screen.dart';
import 'package:silsila_e_azeemia_dashboard/screens/public/home/home_screen.dart';
import 'package:silsila_e_azeemia_dashboard/screens/public/login/login_screen.dart';
import 'package:silsila_e_azeemia_dashboard/screens/public/media_gallery/media_gallery_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ur'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('ur'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'title'.tr(),
      theme: ThemeData(
        fontFamily: 'NooriNastaleeq',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      builder: (context, child) {
        return Directionality(textDirection: ui.TextDirection.rtl, child: child!);
      },
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        AboutUsScreen.routeName: (context) => const AboutUsScreen(),
        BooksScreen.routeName: (context) => const BooksScreen(),
        DigestsScreen.routeName: (context) => const DigestsScreen(),
        MediaGalleryScreen.routeName: (context) => const MediaGalleryScreen(),
        ContactUsScreen.routeName: (context) => const ContactUsScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
      },
    );
  }
}
