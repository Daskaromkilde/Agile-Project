import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'quest_info_screen.dart';
import 'task_slider_screen.dart';

class task_selection_screen extends StatefulWidget {
  final String selectedAvatar;
  final String avatarName;
  final GameWidget game;

  const task_selection_screen(
      {super.key,
      required this.selectedAvatar,
      required this.avatarName,
      required this.game});
  @override
  // ignore: library_private_types_in_public_api
  _TaskSelectionScreenState createState() => _TaskSelectionScreenState();
}

class _TaskSelectionScreenState extends State<task_selection_screen> {
  List<QuestTask> tasks = [
    QuestTask(name: 'Push-ups', progress: '0', goal: '100'),
    QuestTask(name: 'Sit-ups', progress: '0', goal: '100'),
    QuestTask(name: 'Squats', progress: '0', goal: '100'),
    QuestTask(name: 'Run', progress: '0', goal: '100KM'),
    QuestTask(name: 'Sprint', progress: '0', goal: '100KM'),
    QuestTask(name: 'Walk', progress: '0', goal: '100KM'),
    QuestTask(name: 'Intervalls', progress: '0', goal: '100'),
    QuestTask(name: 'Stretch', progress: '0', goal: '30MIN'),
    QuestTask(name: 'Yoga', progress: '0', goal: '30MIN'),
    QuestTask(name: 'Study any chosen subject', progress: '0', goal:'30MIN'),
    QuestTask(name: 'Improve your vocabulary', progress: '0', goal:'30MIN'),
    QuestTask(name: 'Read any book', progress: '0', goal: '1HRS'),
    QuestTask(name: 'Beginner math: Solve basic arithmetic problems', progress: '0', goal: '30MIN'),
    QuestTask(name: 'Intermediate math: Solve linear equations', progress: '0', goal: '30MIN'),
    QuestTask(name: 'Advanced math: Solve trigonometric problems', progress: '0', goal: '30MIN'),
    QuestTask(name: 'Expert math: differentiate and integrate various functions', progress: '0', goal: '30MIN'),
    QuestTask(name: 'Watch any educational video/lecture', progress: '0', goal: '1'),
    QuestTask(name: 'Advanced math: Solve problems related to matrices (linear algebra)', progress: '0', goal: '30MIN'),
  ];

  List<QuestTask> unableTasks = [];

  void updateUnableTasks(QuestTask task, bool? isUnable) {
    setState(() {
      if (isUnable ?? false) {
        unableTasks.add(task);
      } else {
        unableTasks.remove(task);
      }
    });
  }

  void proceedToTaskSliderScreen() {
    for (var task in unableTasks) {
      tasks.remove(task);
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => taskSliderScreen(
          selectedAvatar: widget.selectedAvatar,
          tasks: tasks,
          avatarName: widget.avatarName,
          game: widget.game,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Tasks You Cannot Do'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task.name),
            trailing: Checkbox(
              value: unableTasks.contains(task),
              onChanged: (bool? value) {
                updateUnableTasks(task, value);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: proceedToTaskSliderScreen,
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
