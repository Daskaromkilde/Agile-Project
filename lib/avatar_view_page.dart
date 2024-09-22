import 'package:flutter/material.dart';
import 'battle_arena.dart'; // Import the BattleArena screen

class Stat {
  int currentValue;
  int maxValue;

  Stat({required this.currentValue, required this.maxValue});

  void increase(int amount) {
    currentValue = (currentValue + amount).clamp(0, maxValue);
  }

  void increaseMaxValue(int amount) {
    maxValue += amount;
    currentValue = maxValue;
  }
}

class AvatarViewPage extends StatefulWidget {
  final String selectedAvatar;
  final String avatarName;

  const AvatarViewPage({
    super.key,
    required this.selectedAvatar,
    required this.avatarName,
  });

  @override
  _AvatarViewPage createState() => _AvatarViewPage();
}

class _AvatarViewPage extends State<AvatarViewPage> {
  late Stat xp;
  late Stat strength;
  late Stat intelligence;
  late Stat stamina;
  late Stat hp;

  @override
  void initState() {
    super.initState();
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
        title: const Text(
          'Avatar View',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'lib/assets/background.png', // Background image path
              fit: BoxFit.cover,
            ),
          ),
          // Scrollable Content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  // Avatar Name
                  Text(
                    widget.avatarName,
                    style: const TextStyle(
                      fontSize: 28, // Standard size for the avatar name
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Avatar Image
                  Center(
                    child: Image.asset(
                      widget.selectedAvatar,  // Avatar image
                      height: 180,
                      width: 180,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Stats Section
                  const Text(
                    'Avatar Stats',
                    style: TextStyle(
                      fontSize: 24, // Standard size for "Avatar Stats"
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // GridView for Stats
                  GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1.3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    shrinkWrap: true, // Important: Ensures GridView doesn't take infinite height
                    physics: const NeverScrollableScrollPhysics(), // Disable GridView scrolling
                    children: [
                      statCard('XP', xp, Colors.blue),
                      statCard('Strength', strength, Colors.redAccent),
                      statCard('Intelligence', intelligence, Colors.purpleAccent),
                      statCard('Stamina', stamina, Colors.orangeAccent),
                      statCard('HP', hp, Colors.greenAccent),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // "All tasks complete" Battle Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BattleArena()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 2, 11, 41),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        'All tasks complete, you may challenge the boss',
                        style: TextStyle(fontSize: 23, color: Color.fromARGB(255, 21, 202, 27)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to create a card for each stat with a circular progress bar
  Widget statCard(String statName, Stat stat, Color color) {
    return Card(
      color: Colors.black.withOpacity(0.7), // Semi-transparent card background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Padding inside cards
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              statName,
              style: const TextStyle(
                fontSize: 18, // Standard font size for stat names
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            // Circular progress bar
            SizedBox(
              height: 70, // Standard size for progress bar
              width: 70,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: stat.currentValue / stat.maxValue, // Ensure this is a double
                    strokeWidth: 10,
                    backgroundColor: Colors.grey[800],
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                  Center(
                    child: Text(
                      '${stat.currentValue}', // Display only the current value
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16, // Standard text inside progress bar
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10), // Spacer
          ],
        ),
      ),
    );
  }
}
