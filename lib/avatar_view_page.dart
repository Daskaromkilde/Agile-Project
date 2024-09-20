import 'package:flutter/material.dart';

// Class to represent each Stat with current and maximum value
class Stat {
  int currentValue;
  int maxValue;

  Stat({required this.currentValue, required this.maxValue});

  // Increases the current value of the stat, but not beyond the max value
  void increase(int amount) {
    currentValue = (currentValue + amount).clamp(0, maxValue);
  }

  // Increases the max value (for leveling up) and adjusts the current value accordingly
  void increaseMaxValue(int amount) {
    maxValue += amount;
    currentValue = maxValue; // Optional: Heal or fully restore stat on level up
  }
}

class AvatarViewPage extends StatefulWidget {
  final String selectedAvatar;
  final String avatarName;

  const AvatarViewPage(
      {super.key, required this.selectedAvatar, required this.avatarName});

  @override
  _AvatarViewPage createState() => _AvatarViewPage();
}

class _AvatarViewPage extends State<AvatarViewPage> {
  // Stats are represented as instances of Stat class
  late Stat xp;
  late Stat strength;
  late Stat intelligence;
  late Stat stamina;
  late Stat hp;

  @override
  void initState() {
    super.initState();

    // Initialize stats in initState to ensure they're properly set up
    xp = Stat(currentValue: 150, maxValue: 500);
    strength = Stat(currentValue: 70, maxValue: 100);
    intelligence = Stat(currentValue: 80, maxValue: 100);
    stamina = Stat(currentValue: 90, maxValue: 100);
    hp = Stat(currentValue: 100, maxValue: 200);
  }

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
            // Avatar Name
            Text(
              widget.avatarName,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Avatar Image
            Center(
              child: Image.asset(
                widget.selectedAvatar,
                height: 200,
                width: 200,
              ),
            ),
            const SizedBox(height: 30),

            // Stats Section
            const Text(
              'Avatar Stats',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),

            // Progress Bars for Stats (XP, Strength, etc.)
            statProgressBar('XP', xp),
            statProgressBar('Strength', strength),
            statProgressBar('Intelligence', intelligence),
            statProgressBar('Stamina', stamina),
            statProgressBar('HP', hp),
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
              value: stat.currentValue / stat.maxValue, // Calculate the progress (between 0.0 and 1.0)
              minHeight: 15, // Height of the progress bar
              backgroundColor: Colors.grey[800], // Background color of the bar
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green), // Progress color
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
