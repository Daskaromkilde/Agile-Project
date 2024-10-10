import 'package:first_app/local_data_storage.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'quest_info_screen.dart';
import 'task_slider_screen.dart';

class task_selection_screen extends StatefulWidget {
  final String selectedAvatar;
  final String avatarName;
  final GameWidget game;

  final double taskDiff;

  const task_selection_screen({
    super.key,
    required this.selectedAvatar,
    required this.avatarName,
    required this.game,
    required this.taskDiff
  });

  @override
  // ignore: library_private_types_in_public_api
  _TaskSelectionScreenState createState() => _TaskSelectionScreenState();
}

class _TaskSelectionScreenState extends State<task_selection_screen> {
  late DataStorage _dataStorage;

  List<QuestTask> tasks = [];
  List<QuestTask> unableTasks = [];

  @override
  void initState() {
    super.initState();
    _dataStorage = DataStorage();
    tasks = generateTasks();
    filterTasksByDifficulty();
    loadUnableTasks();
  }

  void filterTasksByDifficulty() {
    TaskDiff selectedDiff;
    if (widget.taskDiff == 0) {
      selectedDiff = TaskDiff.easy;
    } else if (widget.taskDiff == 50) {
      selectedDiff = TaskDiff.medium;
    } else if (widget.taskDiff == 100) {
      selectedDiff = TaskDiff.hard;
    } else {
      return; // If taskDiff is not 0, 50, or 100, do nothing
    }

    tasks = tasks.where((task) => task.diff == selectedDiff).toList();
  }

  Future<void> loadUnableTasks() async {
    final unableTasks = await _dataStorage.loadUnableTasks();
    setState(() {
      this.unableTasks = tasks.where((task) => unableTasks.contains(task.name)).toList();
    });
  }

  // Function to generate tasks with varying difficulty
  List<QuestTask> generateTasks() {
    List<QuestTask> generatedTasks = [];

    // List of exercises
    List<String> physicalExercises = [
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

    List<String> educationalSubjects = [
        'Study a subject',
        'Improve vocabulary',
        'Read a book',
        'Arithmetics',
        'Linear equations',
        'Trigonometric problems',
        'Differentiate/integrate',
        'Watch a video/lecture',
        'Solve matrices'
    ];

    // Define goals for each difficulty
Map<TaskDiff, String> difficultyGoals(String exercise) {
  if (exercise == 'Walk' || exercise == 'Sprint' || exercise == 'Run') {
    return {
      TaskDiff.easy: '1KM',
      TaskDiff.medium: '2KM',
      TaskDiff.hard: '5KM',
    };
  } else if (exercise == 'Yoga' ||
      exercise == 'Stretch' ||
      exercise == 'Breathe') {
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

Map<TaskDiff, String> educationalGoals(String subject) {
  if (subject == 'Study a subject' || subject == 'Watch a video/lecture') {
    return {
      TaskDiff.easy: '15MIN',
      TaskDiff.medium: '30MIN',
      TaskDiff.hard: '45MIN',
    };
  } else if (subject == 'Improve vocabulary' ||
      subject == 'Arithmetics' ||
      subject == 'Trigonometric problems') {
    return {
      TaskDiff.easy: '15MIN',
      TaskDiff.medium: '30MIN',
      TaskDiff.hard: '45MIN',
    };
  } else {
    return {
      TaskDiff.easy: '15MIN',
      TaskDiff.medium: '30MIN',
      TaskDiff.hard: '45MIN',
    };
  }
}

// Generate tasks for each exercise and educational task with each difficulty
for (String exercise in physicalExercises) {
  generatedTasks.add(QuestTask(
      name: exercise,
      goal: difficultyGoals(exercise)[TaskDiff.easy]!,
      type: TaskType.physical,
      diff: TaskDiff.easy));
  generatedTasks.add(QuestTask(
      name: exercise,
      goal: difficultyGoals(exercise)[TaskDiff.medium]!,
      type: TaskType.physical,
      diff: TaskDiff.medium));
  generatedTasks.add(QuestTask(
      name: exercise,
      goal: difficultyGoals(exercise)[TaskDiff.hard]!,
      type: TaskType.physical,
      diff: TaskDiff.hard));
}

for (String subject in educationalSubjects) {
  generatedTasks.add(QuestTask(
      name: subject,
      goal: educationalGoals(subject)[TaskDiff.easy]!,
      type: TaskType.educational,
      diff: TaskDiff.easy));
  generatedTasks.add(QuestTask(
      name: subject,
      goal: educationalGoals(subject)[TaskDiff.medium]!,
      type: TaskType.educational,
      diff: TaskDiff.medium));
  generatedTasks.add(QuestTask(
      name: subject,
      goal: educationalGoals(subject)[TaskDiff.hard]!,
      type: TaskType.educational,
      diff: TaskDiff.hard));
}

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
    _dataStorage.saveUnableTasks(unableTasks.map((task) => task.name).toList());
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
          taskDiff: widget.taskDiff
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
