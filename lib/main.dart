import 'package:flutter/material.dart';
import 'package:fluttertest/avatar_select_page.dart';
import 'quest_info_screen.dart'; // Import your QuestInfoScreen

void main() {
  runApp(QuestApp());
}

class QuestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quest Info',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey[900],
        scaffoldBackgroundColor: Colors.blueGrey[900],
      ),
      home: AvatarSelectPage(), // Set QuestInfoScreen as the home screen
    );
  }
}
