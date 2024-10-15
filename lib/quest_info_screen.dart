import 'dart:async';
import 'dart:math';
import 'package:first_app/playerStats.dart';
import 'local_data_storage.dart';
import 'avatar_view_page.dart';
import 'package:flutter/material.dart';
import 'avatar_select_page.dart'; // Import the AvatarSelectPage
import 'package:flame/game.dart';
import 'quest_info_detail.dart';
import 'task_selection_screen.dart';

  enum TaskType{
    educational,
    physical,
  }

  enum TaskDiff{
    easy,
    medium,
    hard,
  }

class QuestTask {
  String name;
  bool isCompleted;
  String goal;
  TaskType type;
  TaskDiff diff;

  QuestTask({
    required this.name,
    this.isCompleted = false,
    required this.goal,
    required this.type,
    required this.diff,
  });

  String taskTypeToString(TaskType type) {
    return type.toString().split('.').last;
  }

  // Convert TaskDiff to string
  String taskDiffToString(TaskDiff diff) {
    return diff.toString().split('.').last;
  }

  // Convert JSON to QuestTask object
  factory QuestTask.fromJson(Map<String, dynamic> json) {
    return QuestTask(
      name: json['name'],
      isCompleted: json['isCompleted'],
      goal: json['goal'],
      type: TaskType.values.firstWhere((e) => e.toString() == 'TaskType.${json['type']}'),
      diff: TaskDiff.values.firstWhere((e) => e.toString() == 'TaskDiff.${json['diff']}'),
    );
  }

  // Convert QuestTask object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isCompleted': isCompleted,
      'goal': goal,
      'type': taskTypeToString(type),
      'diff': taskDiffToString(diff),
    };
  }
}

class QuestInfoScreen extends StatefulWidget {
  final String selectedAvatar;
  final String avatarName;
  final List<QuestTask> tasks;
  final GameWidget game;
  final double taskCategory;
  final double taskDifficulty;

  const QuestInfoScreen({
    super.key,
    required this.selectedAvatar,
    required this.tasks,
    required this.avatarName,
    required this.game,
    required this.taskCategory,
    required this.taskDifficulty
  });

  @override
  _QuestInfoScreenState createState() => _QuestInfoScreenState();
}

class _QuestInfoScreenState extends State<QuestInfoScreen> {
  
  List<QuestTask> todoTasks = [];
  Duration remainingTime = Duration.zero;
  Timer? countdownTimer;
  int taskAmount = 4; // max 4
  late int weight; // parse sliderValue to range 0-4
  int strAmount = 0;
  int intAmount = 0;
  late DataStorage dataStorage;

  bool allTasksDone() {
    return todoTasks.every((task) => task.isCompleted);
  }

  void updateTask(QuestTask task, bool? isCompleted) {
    setState(() {
      task.isCompleted = isCompleted ?? false;
    });
  }


  void newTasks() {
    setState(() {
      createTasks(taskAmount);
      for (var task in widget.tasks) {
        task.isCompleted = false;
      }
    });
  }

/// Algorith to calculate the amount n tasks of both types, value = n amount
  calculateTaskWeight() {
    strAmount = weight;
    intAmount = taskAmount - strAmount;
  }

void createTasks(int taskAmount) {
  taskAmount = 4;  // We always want 4 tasks.

  if (widget.tasks.isEmpty) {
    return;
  }

  TaskDiff selectedDiff = TaskDiff.medium;
  if(widget.taskDifficulty < 50){
    selectedDiff = TaskDiff.easy;
  }
  else if(widget.taskDifficulty == 50){
    selectedDiff = TaskDiff.medium;
  }
  else if(widget.taskDifficulty > 50){
    selectedDiff = TaskDiff.hard;
  }

  // Calculate the proportion of physical tasks based on the slider value
  int physicalCount = ((widget.taskCategory / 100) * taskAmount).round(); // How many physical tasks
  int educationalCount = taskAmount - physicalCount; // The rest should be educational

  // Ensure we don't exceed available tasks
  physicalCount = physicalCount.clamp(0, widget.tasks.where((task) => task.type == TaskType.physical).length);
  educationalCount = educationalCount.clamp(0, widget.tasks.where((task) => task.type == TaskType.educational).length);

  // Randomly select the tasks
  Random random = Random();
  List<int> randomInts = [];
  todoTasks.clear(); // Clear the list before adding new tasks

  // Add physical tasks
  List<QuestTask> physicalTasks = widget.tasks.where((task) => task.type == TaskType.physical && task.diff == selectedDiff).toList();
  for (var i = 0; i < physicalCount; i++) {
    if (physicalTasks.isEmpty) break; // In case there are no more available tasks

    int randomIndex = random.nextInt(physicalTasks.length);
    while (randomInts.contains(randomIndex)) {
      randomIndex = random.nextInt(physicalTasks.length);
    }
    randomInts.add(randomIndex);
    todoTasks.add(physicalTasks[randomIndex]);
  }

  // Reset randomInts for educational tasks
  randomInts.clear();

  // Add educational tasks
  List<QuestTask> educationalTasks = widget.tasks.where((task) => task.type == TaskType.educational && task.diff == selectedDiff).toList();
  for (var i = 0; i < educationalCount; i++) {
    if (educationalTasks.isEmpty) break; // In case there are no more available tasks

    int randomIndex = random.nextInt(educationalTasks.length);
    while (randomInts.contains(randomIndex)) {
      randomIndex = random.nextInt(educationalTasks.length);
    }
    randomInts.add(randomIndex);
    todoTasks.add(educationalTasks[randomIndex]);
    
  }

  // If we haven't filled 4 tasks, fill the remainder with any type of task (either educational or physical)
  while (todoTasks.length < taskAmount) {
    // Get remaining tasks of both types
    List<QuestTask> remainingTasks = widget.tasks.where((task) => !todoTasks.contains(task)).toList();
    
    if (remainingTasks.isEmpty) {
      break; // If no more tasks are available, we stop
    }

    int randomIndex = random.nextInt(remainingTasks.length);
    todoTasks.add(remainingTasks[randomIndex]);

  }
  dataStorage.saveTaskList(todoTasks);
}

  // Calculates the remaining time to midnight
  Duration timeUntilMidnight() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return tomorrow.difference(now);
  }

  void startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        remainingTime = timeUntilMidnight();
        if (remainingTime.isNegative || remainingTime == Duration.zero) {
          countdownTimer?.cancel();
        }
        
        final now = DateTime.now();
        if ((now.hour == 23 && now.minute == 59 && now.second == 1) && !allTasksDone()) {
          PlayerStats.decreaseAllStats(10); // Decrease all stats by 10, might have to change depending on receive rewards system later
        }
        if ((now.hour == 14 && now.minute == 0 && now.second == 1 ||
                now.hour == 20 && now.minute == 0 && now.second == 1) &&
            !allTasksDone()) {
          final hours = remainingTime.inHours;
          final minutes = remainingTime.inMinutes.remainder(60);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Daily Quest Incomplete!'),
                content: Text(
                  'You haven\'t forgotten about your daily tasks right?\n\n'
                  'Time is running out!, you have $hours hours and $minutes minutes left!',
                ),
              );
            },
          );
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    DataStorage dataStorage = DataStorage();
    weight = (widget.taskCategory/25).round(); // based on sliderValue, decide the amount of types of tasks
    startCountdown(); // Start the 24-hour daily task countdown
    createTasks(taskAmount); // Generate initial tasks

    // Set the size of the game
    // Adjust the size as needed
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Back button at the top-left corner
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const AvatarSelectPage(), // Navigates back to AvatarSelectPage
              ),
            );
          },
        ),
        title: const Text('Quest Info'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/background.png'), // Your background image
                fit: BoxFit.cover, // Covers the whole screen
              ),
            ),
          ),

          // Semi-Transparent Background for the entire screen
          Container(
            color: Colors.black
                .withOpacity(0.3), // Covers the whole screen with 50% opacity
          ),

          // Your content
          Column(
            children: [
              // Add the game widget here
              const SizedBox(
                  height:
                      40), // Added space to move the quest info section down

              // Title section with background and icon
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(128, 6, 38,
                      64), // This is 50% opacity (alpha value = 128),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.info_outline,
                              color: Colors.white, size: 30),
                          onPressed: () {
                            // Show the dialog with quest info
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Quest Info'),
                                  content: const Text(
                                    // add info about quest here
                                    'Here is some detailed information about the quest. \n'
                                    'You can add more content here as per your requirements.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        const Text(
                          'QUEST INFO',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Daily Quest - Train to Evolve',
                      style: TextStyle(
                        fontSize: 16, // Smaller font size
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 45),

              // "Goals" heading in green
              const Text(
                'Goals',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(57, 233, 63, 1),
                ),
              ),

              const SizedBox(height: 30),

              // Goals list section with checkboxes
              Expanded(
                child: ListView.builder(
                  itemCount: todoTasks.length,
                  itemBuilder: (context, index) {
                    return QuestItem(
                      task: todoTasks[index],
                      onChanged: (value) => updateTask(todoTasks[index], value),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              // Conditionally display the button if all tasks are done
              if (allTasksDone())
                ElevatedButton(
                  onPressed: () {
                    newTasks();

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AlertDialog(
                          title: Text('Congratulations!'),
                          content: Text('You have earned your rewards!'),
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    textStyle: const TextStyle(
                        fontSize: 18), // Making the button text bigger
                  ),
                  child: const Text('Receive Rewards'),
                ),

              const SizedBox(height: 20),

              // Caution text section
              const Text(
                'CAUTION! - If the daily quest\nremains incomplete, penalties\nwill be given accordingly.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),

              const SizedBox(height: 30),

              // Timer row at the bottom
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.timer, color: Colors.white, size: 28),
                  const SizedBox(
                      width: 10), // Space between timer and countdown
                  Text(
                    '${remainingTime.inHours}:${remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0')}:${remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),

          // Avatar positioned in the top-right corner
          Positioned(
            top: 170,
            right: 10,
            child: GestureDetector(
              onTap: () {
                widget.game.game?.detach();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AvatarViewPage(
                      selectedAvatar: widget.selectedAvatar,
                      avatarName: widget.avatarName,
                      game: widget.game,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color.fromARGB(205, 0, 0, 0), // Outline color
                    width: 3.0, // Outline width
                  ),
                ),
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: const Color.fromARGB(195, 12, 88, 109),
                  child: ClipOval(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Transform.scale(
                        scale: 0.35,
                        alignment: const Alignment(0, 0.5),
                        child: widget.game,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuestItem extends StatelessWidget {
  final QuestTask task;
  final Function(bool?)? onChanged;

  const QuestItem({super.key, required this.task, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                value: task.isCompleted,
                onChanged: onChanged,
              ),
              Text(
                task.name,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
          Text(
            '[${task.goal}]',
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
