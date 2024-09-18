import 'package:flutter/material.dart';
import 'quest_info_screen.dart';

class task_selection_screen extends StatefulWidget {
  final String selectedAvatar;

  const task_selection_screen({super.key, required this.selectedAvatar});
  @override
  // ignore: library_private_types_in_public_api
  _TaskSelectionScreenState createState() => _TaskSelectionScreenState();
}

class _TaskSelectionScreenState extends State<task_selection_screen> {
  List<QuestTask> tasks = [
    QuestTask(name: 'Push-ups', progress: '[0/100]'),
    QuestTask(name: 'Sit-ups', progress: '[0/100]'),
    QuestTask(name: 'Squats', progress: '[0/100]'),
    QuestTask(name: 'Run', progress: '[0/7KM]'),
    QuestTask(name: 'Sprint', progress: '[1KM]'),
    QuestTask(name: 'Walk', progress: '[0/10KM]'),
    QuestTask(name: 'Intervalls', progress: '[0/5KM]'),
    QuestTask(name: 'Stretch', progress: '[0/30MIN]'),
    QuestTask(name: 'Yoga', progress: '[0/30MIN]'),
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

  void proceedToQuestInfoScreen() {
    for (var task in unableTasks) {
      tasks.remove(task);
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestInfoScreen(
          selectedAvatar: widget.selectedAvatar,
          tasks: tasks,
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
        onPressed: proceedToQuestInfoScreen,
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
