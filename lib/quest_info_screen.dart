import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:first_app/local_data_storage.dart';
import 'package:first_app/playerStats.dart';
import 'avatar_view_page.dart';
import 'package:flutter/material.dart';
import 'avatar_select_page.dart'; // Import the AvatarSelectPage
import 'package:flame/game.dart';
import 'api_service.dart';
import 'dart:ui';

enum TaskType {
  educational,
  physical,
}

enum TaskDiff {
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
}

class QuestInfoScreen extends StatefulWidget {
  final String selectedAvatar;
  final String avatarName;
  final List<QuestTask> tasks;
  final GameWidget game;
  final double taskCategory;
  final double taskDifficulty;

  const QuestInfoScreen(
      {super.key,
      required this.selectedAvatar,
      required this.tasks,
      required this.avatarName,
      required this.game,
      required this.taskCategory,
      required this.taskDifficulty});

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
  late String avatarName;
  final FirestoreService _firestoreService = FirestoreService();
  late Future<List<Map<String, dynamic>>> futureTasks;

  bool checkIfWitch() {
    return avatarName == 'blue_witch';
  }

  void givePlayerExp() {
    // HERE you add exp to player
    PlayerStats.increaseAllStats(35);
    dataStorage.savePlayerStats();
  }

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
    taskAmount = 4; // We always want 4 tasks.

    if (widget.tasks.isEmpty) {
      return;
    }

    TaskDiff selectedDiff = TaskDiff.medium;
    if (widget.taskDifficulty < 50) {
      selectedDiff = TaskDiff.easy;
    } else if (widget.taskDifficulty == 50) {
      selectedDiff = TaskDiff.medium;
    } else if (widget.taskDifficulty > 50) {
      selectedDiff = TaskDiff.hard;
    }

    // Calculate the proportion of physical tasks based on the slider value
    int physicalCount = ((widget.taskCategory / 100) * taskAmount)
        .round(); // How many physical tasks
    int educationalCount =
        taskAmount - physicalCount; // The rest should be educational

    // Ensure we don't exceed available tasks
    physicalCount = physicalCount.clamp(
        0, widget.tasks.where((task) => task.type == TaskType.physical).length);
    educationalCount = educationalCount.clamp(0,
        widget.tasks.where((task) => task.type == TaskType.educational).length);

    // Randomly select the tasks
    Random random = Random();
    List<int> randomInts = [];
    todoTasks.clear(); // Clear the list before adding new tasks

    // Add physical tasks
    List<QuestTask> physicalTasks = widget.tasks
        .where((task) =>
            task.type == TaskType.physical && task.diff == selectedDiff)
        .toList();
    for (var i = 0; i < physicalCount; i++) {
      if (physicalTasks.isEmpty) {
        break; // In case there are no more available tasks
      }

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
    List<QuestTask> educationalTasks = widget.tasks
        .where((task) =>
            task.type == TaskType.educational && task.diff == selectedDiff)
        .toList();
    for (var i = 0; i < educationalCount; i++) {
      if (educationalTasks.isEmpty) {
        break; // In case there are no more available tasks
      }

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
      List<QuestTask> remainingTasks =
          widget.tasks.where((task) => !todoTasks.contains(task)).toList();

      if (remainingTasks.isEmpty) {
        break; // If no more tasks are available, we stop
      }

      int randomIndex = random.nextInt(remainingTasks.length);
      todoTasks.add(remainingTasks[randomIndex]);
    }
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
        if ((now.hour == 23 && now.minute == 59 && now.second == 1) &&
            !allTasksDone()) {
          PlayerStats.decreaseAllStats(
              10); // Decrease all stats by 10, might have to change depending on receive rewards system later
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
    futureTasks = _firestoreService.fetchTasks();
    debugPrint('Selected Avatar Name: ${widget.selectedAvatar}');
    avatarName = widget.selectedAvatar;
    DataStorage dataStorage = DataStorage();
    weight = (widget.taskCategory / 25)
        .round(); // based on sliderValue, decide the amount of types of tasks
    startCountdown(); // Start the 24-hour daily task countdown
    createTasks(taskAmount); // Generate initial tasks
    dataStorage.loadPlayerStats(); // Loads PlayerStats
    //dataStorage.savePlayerStats(); // Saves PlayerStats

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
          FutureBuilder<List<Map<String, dynamic>>>(
            future: futureTasks,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    var task = snapshot.data![index];
                    return ListTile(
                      title: Text(task['title']),
                      trailing: Checkbox(
                        value: task['isCompleted'],
                        onChanged: (bool? value) {
                          setState(() {
                            task['isCompleted'] = value!;
                          });
                          _firestoreService.saveTask(task['title'], value!);
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),

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

          BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
              child: Container()),

          // Semi-Transparent Background for the entire screen
          Container(
            color: Colors.black
                .withOpacity(0.5), // Covers the whole screen with 50% opacity
          ),

          Stack(
            children: [
              // Other content in the background
              Positioned(
                bottom: -40, // Adjust the distance from the bottom
                left: 0,
                right: 0, // Adjust the horizontal position
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/stonePedestal.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  height: 400, // Manually control height to resize it
                  width: 400, // Manually control width to resize it
                ),
              ),
            ],
          ),

          // Your content
          Column(
            children: [
              // Add the game widget here
              const SizedBox(
                  height:
                      20), // Added space to move the quest info section down

              // Title section with background and icon
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(128, 6, 38, 64),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.info_outline,
                              color: Colors.white, size: 30),
                          onPressed: () {
                            // Show the dialog with quest info
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Tasks Info'),
                                  content: const Text(
                                    // add info about quest here
                                    'You progress by completing tasks through filling in the checkboxes. \n \n'
                                    'When all daily tasks are completed, you will be rewarded with an increase in your stats.\n \n'
                                    'If any task is incomplete when the timer reaches zero, penalties will be applied.\n \n'
                                    'Press your character to view stats and fight the boss',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        const Text(
                          'Daily Tasks - Train to Evolve',
                          style: TextStyle(
                            fontSize: 27, // Smaller font size
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Align to center
                        children: [
                          const Icon(Icons.timer, color: Colors.white),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${remainingTime.inHours}:${remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0')}:${remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        ]),
                  ],
                ),
              ),

              const SizedBox(height: 50), // Move task list

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

              // Conditionally display the button if all tasks are done
              if (allTasksDone())
                ElevatedButton(
                  onPressed: () {
                    newTasks();
                    givePlayerExp(); // Hardcoded to 35 points
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
                        horizontal: 20, vertical: 20),
                    textStyle: const TextStyle(fontSize: 22),
                    // Making the button text bigger
                    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                    backgroundColor: const Color.fromARGB(255, 63, 61, 61),
                    iconColor: Colors.white,
                  ),
                  child: const Text('Receive Rewards'),
                ),

              const SizedBox(
                  height: 15), // move "revieve rewards" up with larger number
            ],
          ),

          // Avatar positioned in middlebottom
          // GameWidget(game: BlueWitchGame()) == GameWidgetState ? 500 : 450, //450 standard 500 for witch
          Positioned(
            top: checkIfWitch() ? 500 : 450,
            left: 0,
            right: 0,
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
                    color: const Color.fromARGB(0, 0, 0, 0), // Outline color
                    width: 3.0, // Outline width
                  ),
                ),
                child: CircleAvatar(
                  radius: 140,
                  backgroundColor: const Color.fromARGB(0, 12, 88, 109),
                  child: ClipOval(
                    child: SizedBox(
                      width: 280,
                      height: 280,
                      child: Transform.scale(
                        scale: 0.9,
                        alignment: const Alignment(0, 3.2),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _firestoreService.saveTask('New Task', false);
          setState(() {
            futureTasks = _firestoreService.fetchTasks();
          });
        },
        child: Icon(Icons.add),
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
                activeColor: const Color.fromARGB(255, 56, 163, 252), //HÄR
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
