import 'package:flutter/material.dart';
import 'package:myvideo/NavigationPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NavigationPage()
    );
  }
}

