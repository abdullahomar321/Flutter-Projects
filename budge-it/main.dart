import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ecom_app/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecom App',
      theme: ThemeData(
        fontFamily: 'Jost',
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: home(),
    );
  }
}
