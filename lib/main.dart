import 'package:first_app/avatar_select_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const QuestApp());
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
