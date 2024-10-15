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
  final GameWidget
      avatar; // Pass game instance from outside, which is the selected avatar

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
  late BossGame game; // Declare the game instance for Boss
  late GameWidget avatarGame; // GameWidget passed from widget
  int bossHP = 300; // Initial boss HP
  int hpIncrement = 100; // Increment boss HP after each victory

  @override
  void initState() {
    super.initState();
    game = BossGame(); // Initialize the main game (BossGame)
    avatarGame = widget.avatar; // Use the passed GameWidget instance
  }

  @override
  void dispose() {
    game.onDetach(); // Properly detach the boss game when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int totalPlayerStats = widget.strength +
        widget.intelligence +
        widget.stamina +
        widget.hp +
        widget.level;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/pxArt.png'), // Your background image
          fit: BoxFit.cover, // Covers the whole screen
        ),
      ),
      child: Scaffold(
        backgroundColor:
            Colors.transparent, // Make the scaffold background transparent
        appBar: AppBar(
          title: const Text('Battle Arena'),
          backgroundColor: const Color.fromARGB(255, 80, 18, 206),
        ),
        body: Stack(
          children: [
            // Player Stats on the Left
            Positioned(
              bottom:
                  100.0, // Adjusted margin from the bottom to move it higher
              left: 20.0, // Adjusted margin from the left
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your total stats: $totalPlayerStats',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 100, // Set a specific width
                    height: 100, // Set a specific height
                    child: avatarGame, // Use the passed game widget (avatar)
                  ),
                ],
              ),
            ),
            // Boss HP and Animation on the Right
            Positioned(
              top: 30.0, // Adjusted margin from the top
              right: 20.0, // Adjusted margin from the right
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Boss HP: $bossHP',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 150, // Set height for the boss animation container
                    width: 150, // Set width for the boss animation container
                    child: GameWidget(
                        game: game), // Use the game instance for the boss
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
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
        ),
      ),
    );
  }
}
