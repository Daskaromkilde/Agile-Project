import 'dart:async';
import 'dart:math';
import 'avatar_view_page.dart';

import 'package:flutter/material.dart';

class QuestTask {
  String name;
  bool isCompleted;
  String progress;

  QuestTask(
      {required this.name, this.isCompleted = false, required this.progress});
}

class QuestInfoScreen extends StatefulWidget {
  final String selectedAvatar;
  final List<QuestTask> tasks;

  const QuestInfoScreen(
      {super.key, required this.selectedAvatar, required this.tasks});

  @override
  _QuestInfoScreenState createState() => _QuestInfoScreenState();
}

class _QuestInfoScreenState extends State<QuestInfoScreen> {
  // List<QuestTask> tasks = [
  //   //workout exercises
  //   QuestTask(name: 'Push-ups', progress: '[0/100]'),
  //   QuestTask(name: 'Sit-ups', progress: '[0/100]'),
  //   QuestTask(name: 'Squats', progress: '[0/100]'),
  //   QuestTask(name: 'Run', progress: '[0/7KM]'),
  //   QuestTask(name: 'Sprint', progress: '[1KM]'),
  //   QuestTask(name: 'Walk', progress: '[0/10KM]'),
  //   QuestTask(name: 'Intervalls', progress: '[0/5KM]'),
  //   QuestTask(name: 'Stretch', progress: '[0/30MIN]'),
  //   QuestTask(name: 'Yoga', progress: '[0/30MIN]'),
  // ];

  List<QuestTask> todoTasks = [
    //todo exercises
  ];

  Duration remainingTime = Duration.zero;
  Timer? countdownTimer;

  int taskAmount = 4;

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
      createTasks();
      for (var task in widget.tasks) {
        task.isCompleted = false;
        task.progress = '[0/100]';
      }
    });
  }

  void createTasks() {
    if (widget.tasks.length < taskAmount) {
      taskAmount = widget.tasks.length;
    }
    if (widget.tasks.isEmpty) {
      return;
    }
    Random random = Random();
    List<int> randomInts = [];
    todoTasks.clear(); // Clear the list before adding new tasks
    for (var i = 0; i < taskAmount; i++) {
      int randomIndex = random.nextInt(widget.tasks.length);
      while (randomInts.contains(randomIndex)) {
        randomIndex = random.nextInt(widget.tasks.length);
      }
      randomInts.add(randomIndex);
      todoTasks.add(widget.tasks[randomIndex]);
    }
  }

// Calculates the remaining time to midnight from the inital time on app startup
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
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startCountdown(); // Start the 24 hour daily task countdown
    createTasks(); // Generate initial tasks
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
              height: 40), // Added space to move the quest info section down

          // Title section with background and icon
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 6, 38, 64),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, color: Colors.white, size: 28),
                SizedBox(width: 10),
                Text(
                  'QUEST INFO',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Subtitle section
          const Text(
            'Daily Quest - Train to Evolve',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white),
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

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AvatarViewPage(
                          selectedAvatar: widget.selectedAvatar)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[800], // Background color
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'View Avatar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
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

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.timer, color: Colors.white, size: 48),
              const SizedBox(height: 20), // Timer icon

              Text(
                'Time Until Midnight: ${remainingTime.inHours}:${remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0')}:${remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              // const Icon(Icons.timer, color: Colors.white, size: 48),
            ],
          )
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
            task.progress,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
