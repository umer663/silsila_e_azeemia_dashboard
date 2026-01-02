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
import 'package:silsila_e_azeemia_dashboard/screens/private/books_upload/books_upload_screen.dart';
import 'package:silsila_e_azeemia_dashboard/screens/private/dashboard/dashboard_screen.dart';
import 'package:silsila_e_azeemia_dashboard/screens/private/digests_upload/digests_upload_screen.dart';
import 'package:silsila_e_azeemia_dashboard/screens/private/media_upload/media_upload_screen.dart';
import 'package:silsila_e_azeemia_dashboard/screens/private/reports/reports_screen.dart';
import 'package:silsila_e_azeemia_dashboard/screens/private/users_management/users_management_screen.dart';
import 'package:silsila_e_azeemia_dashboard/utils/no_transitions_builder.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");

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
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: NoTransitionsBuilder(),
            TargetPlatform.iOS: NoTransitionsBuilder(),
            TargetPlatform.linux: NoTransitionsBuilder(),
            TargetPlatform.windows: NoTransitionsBuilder(),
            TargetPlatform.macOS: NoTransitionsBuilder(),
          },
        ),
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
        DashboardScreen.routeName: (context) => const DashboardScreen(),
        BooksUploadScreen.routeName: (context) => const BooksUploadScreen(),
        DigestsUploadScreen.routeName: (context) => const DigestsUploadScreen(),
        MediaUploadScreen.routeName: (context) => const MediaUploadScreen(),
        UsersManagementScreen.routeName: (context) => const UsersManagementScreen(),
        ReportsScreen.routeName: (context) => const ReportsScreen(),
      },
    );
  }
}
