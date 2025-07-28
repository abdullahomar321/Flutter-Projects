import 'package:flutter/material.dart';
import 'package:notifyme/home.dart';
import 'package:notifyme/intro.dart';
import 'package:provider/provider.dart';
import 'package:notifyme/noteprovider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => NoteProvider()..loadNotes(),
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
      home: const intro(),
      routes: {
        '/home': (context) => const Home(),
        '/intro': (context) => const intro(),
      },
    );
  }
}
