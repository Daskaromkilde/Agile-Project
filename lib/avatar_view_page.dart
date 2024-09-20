import 'dart:math';

import 'package:flutter/material.dart';

class AvatarViewPage extends StatefulWidget {
  final String selectedAvatar;
  final String avatarName;

  const AvatarViewPage(
      {super.key, required this.selectedAvatar, required this.avatarName});

  @override
  _AvatarViewPage createState() => _AvatarViewPage();
}

class _AvatarLevel {
  int level = 0;
  int experience = 0;
  int experienceToNextLevel = 100;

  int getLevel() {
    return level;
  }

  _AvatarLevel(this.level, this.experience);

  void increaseLevel() {
    experience = 0;
    level++;
    Random random = Random();
    int nextRandom = random.nextInt(level); // exponential growth
    experienceToNextLevel = level * 2 ^ nextRandom;
  }

  void increaseExperience(int exp) {
    experience += exp;
    if (experience >= experienceToNextLevel) {
      increaseLevel();
    }
  }
}

class _AvatarViewPage extends State<AvatarViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 6, 38, 64),
        title: const Text('Avatar View',
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.avatarName,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Changed to black for better visibility
              ),
            ),
            Center(
              child: Image.asset(
                widget.selectedAvatar,
                height: 200,
                width: 200,
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Level : ',
                    style: TextStyle(
                      fontSize: 21,
                      color: Colors
                          .white, // Changed to black for better visibility
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: 0.7, // Set the progress value (0.0 to 1.0)
                      backgroundColor: Colors.grey[300],
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.blue),
                      minHeight: 15, // Set the height of the progress bar
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
