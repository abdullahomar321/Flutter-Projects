import 'package:flutter/material.dart';
import 'dart:async';

class SplashProvider with ChangeNotifier{
  bool isready=false;
  bool get _isready=> isready;


  SplashProvider(){
    _startDelay();
  }

  void _startDelay() {
  Timer(const Duration(seconds: 2), () {
    isready = true;
    notifyListeners();
  });
}
}
