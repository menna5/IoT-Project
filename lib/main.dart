import 'package:flutter/material.dart';
import 'package:untitled7/Homescreen.dart';
import 'package:untitled7/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName :(context) =>SplashScreen(),
        HomeScreen.routeName : (context)  => HomeScreen(),
      },

      home: HomeScreen(),
    );
  }
}

