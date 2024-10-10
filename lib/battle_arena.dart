import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'boss_game.dart'; // Import your BossGame



class BattleArena extends StatefulWidget {
  final int strength;
  final int intelligence;
  final int stamina;
  final int hp;
  final int level;
  final String selectedAvatar; // Pass selected avatar path from AvatarViewPage
  final String avatarName;
  final GameWidget avatar; // Pass game instance from outside, which is the selected avatar

  const BattleArena({
    super.key,
    required this.strength,
    required this.intelligence,
    required this.stamina,
    required this.hp,
    required this.level,
    required this.selectedAvatar,
    required this.avatarName,
    required this.avatar,
  });

  @override
  _BattleArenaState createState() => _BattleArenaState();
}

class _BattleArenaState extends State<BattleArena> {
  late BossGame game;  // Declare the game instance for Boss
  late GameWidget avatarGame; // GameWidget passed from widget
  int bossHP = 300; // Initial boss HP
  int hpIncrement = 100; // Increment boss HP after each victory

  @override
  void initState() {
    super.initState();
    game = BossGame();  // Initialize the main game (BossGame)
    avatarGame = widget.avatar;  // Use the passed GameWidget instance
  }

  @override
  void dispose() {
    game.onDetach();// Properly detach the boss game when the widget is disposed
    super.dispose();
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
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Text(
                      'Your total stats: $totalPlayerStats',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 140), // Space between text and image

                  // Avatar image using selected avatar from AvatarViewPage
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0), // Adjust the left padding to move it right
                    child: SizedBox(
                      width: 250, // Set a specific width
                      height: 200, // Set a specific height
                      child: avatarGame,  // Use the passed game widget (avatar)
                    ),
                  ),
                ],
              ),
            ),
            // Boss HP and Animation on the Right
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Move down by 50 pixels
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0, right: 20),
                      child: Text(
                        'Boss HP: $bossHP',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                        const SizedBox(height: 80),
                  
                    // Container for Boss Animation (BossGame)
                     SizedBox(
                      height: 300, // Set height for the boss animation container
                      width: 150,  // Set width for the boss animation container
                      child: GameWidget(game: game),  // Use the game instance for the boss            
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
                    bossHP += hpIncrement; // Increase boss HP after win
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
