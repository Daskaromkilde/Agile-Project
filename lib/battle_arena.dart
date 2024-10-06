import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'local_data_storage.dart';
import 'boss_game.dart'; // Import your BossGame
import 'necromancer_game.dart'; // Import avatars from other game files


// Import the file that contains the Stat class

class BattleArena extends StatefulWidget {
  final int strength;
  final int intelligence;
  final int stamina;
  final int hp;
  final int level;
  final String selectedAvatar; // Add avatar path

  const BattleArena({
    super.key,
    required this.strength,
    required this.intelligence,
    required this.stamina,
    required this.hp,
    required this.level,
    required this.selectedAvatar, // Required avatar path
  });
  
  final String selectedAvatar2 = 'assets/images/Necromancer.png';
  
  
  @override
  _BattleArenaState createState() => _BattleArenaState();
}

class _BattleArenaState extends State<BattleArena> {
  late DataStorage dataStorage;
  int bossHP = 300; // Initial boss HP
  int hpIncrement = 100; // Increment boss HP after each victory

  @override
  void initState() {
    super.initState();
    dataStorage = DataStorage();

    dataStorage.loadBossHP().then((loadedBossHP) {
      setState(() {
        bossHP = loadedBossHP;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalPlayerStats = widget.strength +
        widget.intelligence +
        widget.stamina +
        widget.hp +
        widget.level;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Battle Arena'),
        backgroundColor: const Color.fromARGB(255, 80, 18, 206),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Player Stats on the Left
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Adjust padding to wrap the Text widget
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Text(
                      'Your total stats: $totalPlayerStats',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 20), // Space between text and image

                  // Avatar image
                  Image.asset(
                    widget.selectedAvatar2, // Display selected avatar image
                    height: 150,
                    width: 150,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            // Boss HP and Animation on the Right
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0), // Move down by 50 pixels
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Boss HP: $bossHP',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 20),

                        // Container for Boss Animation (BossGame)
                        SizedBox(
                          height: 300, // Set height for the boss animation container
                          width: 200,  // Set width for the boss animation container
                          child: GameWidget(
                            game: BossGame(), // Your boss animation game
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                if (totalPlayerStats > bossHP) {
                  setState(() {

                    // Player wins, increase boss HP for the next round
                    bossHP += hpIncrement;
                    dataStorage.saveBossHP(bossHP);
                    
                  });

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text('Victory!'),
                        content: Text('You defeated the boss!'),
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text('Defeat!'),
                        content: Text('You lost the battle...'),
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                backgroundColor: Colors.redAccent,
              ),
              child: const Text('Fight!'),
            ),
          ],
        ),
      ),
    );
  }
}
