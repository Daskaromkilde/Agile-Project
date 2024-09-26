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
    QuestTask(name: 'Push-ups', progress: '0', goal: '100',type:TaskType.physical),
    QuestTask(name: 'Sit-ups', progress: '0', goal: '100',type:TaskType.physical),
    QuestTask(name: 'Squats', progress: '0', goal: '100',type:TaskType.physical),
    QuestTask(name: 'Run', progress: '0', goal: '100KM',type:TaskType.physical),
    QuestTask(name: 'Sprint', progress: '0', goal: '100KM',type:TaskType.physical),
    QuestTask(name: 'Walk', progress: '0', goal: '100KM',type:TaskType.physical),
    QuestTask(name: 'Intervalls', progress: '0', goal: '100',type:TaskType.physical),
    QuestTask(name: 'Stretch', progress: '0', goal: '30MIN',type:TaskType.physical),
    QuestTask(name: 'Yoga', progress: '0', goal: '30MIN',type:TaskType.physical),
    QuestTask(name: 'Study any chosen subject', progress: '0', goal:'30MIN',type:TaskType.educational),
    QuestTask(name: 'Improve your vocabulary', progress: '0', goal:'30MIN',type:TaskType.educational),
    QuestTask(name: 'Read any book', progress: '0', goal: '1HRS',type:TaskType.educational),
    QuestTask(name: 'Beginner math: Arithmetics', progress: '0', goal: '45MIN',type:TaskType.educational),
    QuestTask(name: 'Intermediate math: Linear equations', progress: '0', goal: '45MIN',type:TaskType.educational),
    QuestTask(name: 'Advanced math: Trigonometic problems', progress: '0', goal: '45MIN',type:TaskType.educational),
    QuestTask(name: 'Expert math: differentiate/integrate functions', progress: '0', goal: '45MIN',type:TaskType.educational),
    QuestTask(name: 'Watch any educational video/lecture', progress: '0', goal: '1',type:TaskType.educational),
    QuestTask(name: 'Advanced math: Solve matrices (linear algebra)', progress: '0', goal: '45MIN',type:TaskType.educational),
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

  List<QuestTask> getEducationalTasks() {
  return tasks.where((task) => task.type == TaskType.educational).toList();
}

List<QuestTask> getPhysicalTasks() {
  return tasks.where((task) => task.type == TaskType.physical).toList();
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
