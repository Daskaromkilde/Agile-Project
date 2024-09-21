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

  // Widget to create a progress bar for each stat
  Widget statProgressBar(String statName, Stat stat) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stat Name and Value
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                statName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                '${stat.currentValue} / ${stat.maxValue}', // Display current and max value
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Progress bar (using LinearProgressIndicator)
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: stat.currentValue /
                  stat.maxValue, // Calculate the progress (between 0.0 and 1.0)
              minHeight: 15, // Height of the progress bar
              backgroundColor: Colors.grey[800], // Background color of the bar
              valueColor: const AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 15, 191, 255)), // Progress color
            ),
          ),
        ],
      ),
    );
  }

  // Function to simulate leveling up, increasing max values
  void levelUp() {
    setState(() {
      // Increase the max values of stats when leveling up
      xp.increaseMaxValue(100);
      strength.increaseMaxValue(20);
      intelligence.increaseMaxValue(20);
      stamina.increaseMaxValue(20);
      hp.increaseMaxValue(50); // HP gets a bigger boost
    });
  }

  // Function to apply a reward to certain stats
  void applyReward(Map<String, int> rewards) {
    setState(() {
      // Map the stat names to the corresponding Stat objects
      final Map<String, Stat> statMap = {
        'xp': xp,
        'strength': strength,
        'intelligence': intelligence,
        'stamina': stamina,
        'hp': hp,
      };

      // Iterate through the rewards and apply them to the correct stat
      rewards.forEach((statName, rewardValue) {
        if (statMap.containsKey(statName)) {
          statMap[statName]!.increase(rewardValue); // Apply the increase
        }
      });
    });
  }
}
