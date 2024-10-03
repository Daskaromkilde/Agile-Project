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
    QuestTask(name: 'Push-ups [Medium]', progress: '0', goal: '100',type:TaskType.physical,diff: TaskDiff.medium),
    QuestTask(name: 'Sit-ups [Medium]', progress: '0', goal: '100',type:TaskType.physical,diff: TaskDiff.medium),
    QuestTask(name: 'Squats [Medium]', progress: '0', goal: '100',type:TaskType.physical,diff: TaskDiff.medium),
    QuestTask(name: 'Run [Hard]', progress: '0', goal: '100KM',type:TaskType.physical,diff: TaskDiff.hard),
    QuestTask(name: 'Sprint [Medium]', progress: '0', goal: '100KM',type:TaskType.physical,diff: TaskDiff.medium),
    QuestTask(name: 'Walk [Easy]', progress: '0', goal: '100KM',type:TaskType.physical,diff: TaskDiff.easy),
    QuestTask(name: 'Intervalls [Hard]', progress: '0', goal: '100',type:TaskType.physical,diff: TaskDiff.hard),
    QuestTask(name: 'Stretch [Easy]', progress: '0', goal: '30MIN',type:TaskType.physical,diff: TaskDiff.easy),
    QuestTask(name: 'Yoga [Medium]', progress: '0', goal: '30MIN',type:TaskType.physical,diff: TaskDiff.medium),
    QuestTask(name: 'Study a subject [Easy]', progress: '0', goal:'30MIN',type:TaskType.educational,diff: TaskDiff.easy),
    QuestTask(name: 'Improve vocabulary [Medium]', progress: '0', goal:'30MIN',type:TaskType.educational,diff: TaskDiff.medium),
    QuestTask(name: 'Read a book [Easy]', progress: '0', goal: '1HRS',type:TaskType.educational,diff: TaskDiff.easy),
    QuestTask(name: 'Arithmetics [Medium]', progress: '0', goal: '45MIN',type:TaskType.educational,diff: TaskDiff.medium),
    QuestTask(name: 'Linear equations [Hard]', progress: '0', goal: '45MIN',type:TaskType.educational,diff: TaskDiff.hard),
    QuestTask(name: 'Trigonometic problems [Medium]', progress: '0', goal: '45MIN',type:TaskType.educational,diff: TaskDiff.medium),
    QuestTask(name: 'differentiate/integrate [Hard]', progress: '0', goal: '45MIN',type:TaskType.educational,diff: TaskDiff.hard),
    QuestTask(name: 'Watch a video/lecture [Easy]', progress: '0', goal: '1',type:TaskType.educational,diff: TaskDiff.easy),
    QuestTask(name: 'Solve matrices  [Hard]', progress: '0', goal: '45MIN',type:TaskType.educational,diff: TaskDiff.hard),
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
  List<QuestTask> getEasyTasks(){
    return tasks.where((task) => task.diff == TaskDiff.easy).toList();
}

  List<QuestTask> getMediumTasks(){
    return tasks.where((task) => task.diff == TaskDiff.medium).toList();
}

  List<QuestTask> gethardTasks(){
    return tasks.where((task) => task.diff == TaskDiff.hard).toList();
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
      padding: const EdgeInsets.only(bottom: 80), // Add padding at the bottom
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
