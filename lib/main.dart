import 'package:flutter/material.dart';
import 'package:blueboxproject/pages/home_page.dart';
import 'package:blueboxproject/pages/detalles_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blue Box challenge',
      initialRoute: '/home',
      routes: {
        "/home": (context) => const MyHomePage(),
        "/detalles": (context) => const Detalles(),
      },
    );
  }
}
