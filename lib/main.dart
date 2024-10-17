import 'package:first_app/authenticator_screen.dart';
import 'package:first_app/notifications_file.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // säkring, vid start av appen medans notif försöker init kan bli bugg
  await NotificationsFile.init();
  await NotificationsFile.reqPerm();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: const AuthScreen(), // Avatar selection is the first screen
    );
  }
}
