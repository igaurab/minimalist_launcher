import 'package:flutter/material.dart';
//import 'screens/HomeScreen.dart';
import 'screens/ListApps.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Launcher',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(0xFFdfe5f0)),
      home: ListAppsPages(),
    );
  }
}
