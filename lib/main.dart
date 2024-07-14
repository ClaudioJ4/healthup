// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors
import 'package:flutter/foundation.dart';
import 'package:healthup/features/app/calendar/screens/calendar_screen.dart';
import 'package:healthup/features/app/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:healthup/features/auth/front/pages/home_page.dart';
import 'package:healthup/features/auth/front/pages/login_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBDOoNqNwBWG2JtYT_tM3nXxHQOnWnALS4",
            appId: "1:775917246848:web:d2b26f71e49040bc1d0965",
            messagingSenderId: "775917246848",
            projectId: "health-up-9fa76"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(
    MainApp(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health App',
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(
              child: LoginPage(),
            ),
        '/home': (context) => HomePage(),
        '/calendar': (context) => CalendarPage(),
      },
    );
  }
}
