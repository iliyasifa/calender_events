import 'package:calender/widgets/calender.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calender Event',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primaryColor: Colors.deepOrangeAccent,
      ),
      home: const CalenderPage(),
      // const EventData(),
    );
  }
}