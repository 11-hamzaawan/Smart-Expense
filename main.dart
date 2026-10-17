import 'package:flutter/material.dart';
import 'welcome_screen.dart';

void main() {
  runApp(const SmartExpenseApp());
}

class SmartExpenseApp extends StatelessWidget {
  const SmartExpenseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartExpense',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const WelcomeScreen(), // Starts at Welcome Screen
    );
  }
}
