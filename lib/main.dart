import 'app_final_mobile/lib/pages/home.dart';
import 'app_final_mobile/lib/pages/homeworks.dart';
import 'app_final_mobile/lib/pages/house.dart';
import 'app_final_mobile/lib/pages/login.dart';
import 'app_final_mobile/lib/pages/register.dart';
import 'app_final_mobile/lib/pages/work.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Principal());
}

class Principal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/principal': (context) => (Principal()),
        '/home': (context) => (Home()),
        '/homework': (context) => (Homework()),
        '/house': (context) => (House()),
        '/login': (context) => (Login()),
        '/register': (context) => (Register()),
        '/work': (context) => (Work()),
      },
    );
  }
}
