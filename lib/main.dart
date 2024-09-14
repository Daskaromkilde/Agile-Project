import 'package:flutter/material.dart';
import 'package:fluttertest/avatar_select_page.dart';

void main() {
  runApp(QuestApp());
}

class QuestApp extends StatelessWidget {
  const QuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quest Info',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey[900],
        scaffoldBackgroundColor: Colors.blueGrey[900],
      ),
      home: AvatarSelectPage(), // Avatar selection is the first screen
    );
  }
}
