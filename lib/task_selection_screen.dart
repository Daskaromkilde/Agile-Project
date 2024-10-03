import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'quest_info_screen.dart';
import 'task_slider_screen.dart';

class task_selection_screen extends StatefulWidget {
  final String selectedAvatar;
  final String avatarName;
  final GameWidget game;

  const task_selection_screen({
    super.key,
    required this.selectedAvatar,
    required this.avatarName,
    required this.game,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TaskSelectionScreenState createState() => _TaskSelectionScreenState();
}

class _TaskSelectionScreenState extends State<task_selection_screen> {
  List<QuestTask> tasks = [];
  List<QuestTask> unableTasks = [];

  @override
  void initState() {
    super.initState();
    tasks = generateTasks();
  }

  // Function to generate tasks with varying difficulty
  List<QuestTask> generateTasks() {
    List<QuestTask> generatedTasks = [];

    // List of exercises
    List<String> exercises = [
      'Stretch',
      'Breathe',
      'Walk',
      'Sit-ups',
      'Sprint',
      'Squats',
      'Intervalls',
      'Push-ups',
      'Yoga',
      'Run'
    ];

    // Define goals for each difficulty
    Map<TaskDiff, String> difficultyGoals(String exercise) {
      if (exercise == 'Walk' || exercise == 'Sprint' || exercise == 'Run') {
        return {
          TaskDiff.easy: '1KM',
          TaskDiff.medium: '2KM',
          TaskDiff.hard: '5KM',
        };
      } else if (exercise == 'Yoga' || exercise == 'Stretch' || exercise == 'Breathe') {
        return {
          TaskDiff.easy: '15MIN',
          TaskDiff.medium: '30MIN',
          TaskDiff.hard: '45MIN',
        };
      } else {
        return {
          TaskDiff.easy: '50',
          TaskDiff.medium: '100',
          TaskDiff.hard: '150',
        };
      }
    }

    // Generate tasks for each exercise with each difficulty
    for (String exercise in exercises) {
      generatedTasks.add(QuestTask(
          name: '$exercise',
          goal: difficultyGoals(exercise)[TaskDiff.easy]!,
          type: TaskType.physical,
          diff: TaskDiff.easy));
      generatedTasks.add(QuestTask(
          name: '$exercise',
          goal: difficultyGoals(exercise)[TaskDiff.medium]!,
          type: TaskType.physical,
          diff: TaskDiff.medium));
      generatedTasks.add(QuestTask(
          name: '$exercise',
          goal: difficultyGoals(exercise)[TaskDiff.hard]!,
          type: TaskType.physical,
          diff: TaskDiff.hard));
    }

    // Add educational tasks manually if needed
    generatedTasks.addAll([
      QuestTask(name: 'Study a subject [Easy]', goal: '30MIN', type: TaskType.educational, diff: TaskDiff.easy),
      QuestTask(name: 'Improve vocabulary [Medium]', goal: '30MIN', type: TaskType.educational, diff: TaskDiff.medium),
      QuestTask(name: 'Read a book [Easy]', goal: '1HRS', type: TaskType.educational, diff: TaskDiff.easy),
      QuestTask(name: 'Arithmetics [Medium]', goal: '45MIN', type: TaskType.educational, diff: TaskDiff.medium),
      QuestTask(name: 'Linear equations [Hard]', goal: '45MIN', type: TaskType.educational, diff: TaskDiff.hard),
      QuestTask(name: 'Trigonometric problems [Medium]', goal: '45MIN', type: TaskType.educational, diff: TaskDiff.medium),
      QuestTask(name: 'Differentiate/integrate [Hard]', goal: '45MIN', type: TaskType.educational, diff: TaskDiff.hard),
      QuestTask(name: 'Watch a video/lecture [Easy]', goal: '1', type: TaskType.educational, diff: TaskDiff.easy),
      QuestTask(name: 'Solve matrices [Hard]', goal: '45MIN', type: TaskType.educational, diff: TaskDiff.hard),
    ]);

    return generatedTasks;
  }

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

  List<QuestTask> getEasyTasks() {
    return tasks.where((task) => task.diff == TaskDiff.easy).toList();
  }

  List<QuestTask> getMediumTasks() {
    return tasks.where((task) => task.diff == TaskDiff.medium).toList();
  }

  List<QuestTask> getHardTasks() {
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
