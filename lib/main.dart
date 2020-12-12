import 'package:appsynergy_ganesh_assignment/auth/auth.dart';
import 'package:appsynergy_ganesh_assignment/auth/auth_manager.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Synergies',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FirebaseAuthManager(
        auth: Auth(),
      ),
    );
  }
}

