import 'package:first_app/avatar_select_page.dart';
import 'package:first_app/local_data_storage.dart';
import 'package:first_app/notifications_file.dart';
import 'package:first_app/quest_info_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // säkring, vid start av appen medans notif försöker init kan bli bugg
  await NotificationsFile.init();
  await NotificationsFile.reqPerm();

  final DataStorage dataStorage = DataStorage();
  final bool completeSetup = await dataStorage.checkCompleteSetup();

  runApp(QuestApp(completeSetup: completeSetup));
}

class QuestApp extends StatelessWidget {
  final bool completeSetup;
  const QuestApp({super.key, required this.completeSetup});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quest Info',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey[900],
        scaffoldBackgroundColor: Colors.blueGrey[900],
      ),
      home: completeSetup ? const QuestInfoScreen() : const AvatarSelectPage(),// here we need to make constructor parameters avail // Avatar selection is the first screen
    );
  }
}
