import 'package:first_app/avatar_select_page.dart';
import 'package:first_app/avatar_utils.dart';
import 'package:first_app/local_data_storage.dart';
import 'package:first_app/notifications_file.dart';
import 'package:first_app/quest_info_screen.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // säkring, vid start av appen medans notif försöker init kan bli bugg
  await NotificationsFile.init();
  await NotificationsFile.reqPerm();
  final DataStorage dataStorage = DataStorage();

  final bool completeSetup = await dataStorage.checkCompleteSetup();

  final String selectedAvatar = (await dataStorage.loadAvatarSaveName())['avatar']!;
  final String avatarName = (await dataStorage.loadAvatarSaveName())['name']!;
  final List<QuestTask> tasks = await dataStorage.loadTaskList();
  final double taskCategory = await dataStorage.loadTaskCategory();
  final double taskDifficulty = await dataStorage.loadTaskDifficulty();


  runApp(QuestApp(
      completeSetup: completeSetup,
      selectedAvatar: selectedAvatar,
      avatarName: avatarName,
      tasks: tasks,
      taskCategory: taskCategory,
      taskDifficulty: taskDifficulty));
}

class QuestApp extends StatelessWidget {
  final bool completeSetup;
  final String selectedAvatar;
  final String avatarName;
  final List<QuestTask> tasks;
  final double taskCategory;
  final double taskDifficulty;
  
  const QuestApp({
    super.key, 
    required this.completeSetup,
    required this.selectedAvatar,
    required this.avatarName,
    required this.tasks,
    required this.taskCategory,
    required this.taskDifficulty
    });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quest Info',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey[900],
        scaffoldBackgroundColor: Colors.blueGrey[900],
      ),
      home: completeSetup ? QuestInfoScreen(
        selectedAvatar: selectedAvatar,
        avatarName: avatarName,
        game: AvatarUtils.getAvatarWidget(selectedAvatar),
        tasks: tasks,
        taskCategory: taskCategory,
        taskDifficulty: taskDifficulty,
      ) : const AvatarSelectPage(),// here we need to make constructor parameters avail // Avatar selection is the first screen
    );
  }
}
