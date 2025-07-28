import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notifyme/home.dart';
import 'package:notifyme/splash_screen.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SplashProvider(),
      child: Consumer<SplashProvider>(
        builder: (context, provider, child) {
          if (provider.isready) {
            Future.microtask(() {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const Home()),
              );
            });
          }

          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Text(
                'Loading...',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}
