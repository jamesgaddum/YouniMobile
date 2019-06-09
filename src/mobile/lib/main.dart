import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:youni/screens/home_screen.dart';
import 'package:flutter/rendering.dart';

void main() {
  //debugPaintSizeEnabled = true;
  //debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Color.fromRGBO(240, 240, 240, 1.0),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: HomeScreen(),
          ),
        ),
      ),
    );
  }
}