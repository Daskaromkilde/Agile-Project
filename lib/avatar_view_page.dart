import 'package:first_app/battle_arena.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:first_app/playerStats.dart';

// Import avatars from other game files

class AvatarViewPage extends StatefulWidget {
  final String selectedAvatar;
  final String avatarName;
  final GameWidget game;

  const AvatarViewPage({
    super.key,
    required this.selectedAvatar,
    required this.avatarName,
    required this.game,
  });

  @override
  _AvatarViewPage createState() => _AvatarViewPage();
}

class _AvatarViewPage extends State<AvatarViewPage> {
  void increaseStat(Stat stat, int amount) {
    setState(() {
      stat.increase(amount);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  // Method to display the correct avatar (either animated or static)

  // Function to create a circular interactive stat
  Widget statCard(String statName, Stat stat, Color color, IconData icon,
      VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap, // Functionality to open the stat detail
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 80, // Circular size
            width: 80,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: stat.currentValue / stat.maxValue,
                  strokeWidth: 10,
                  backgroundColor: Colors.grey[800],
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
                Center(
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            statName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Function to show stat details in a dialog/modal
  void _showStatDetail(BuildContext context, String statName, Stat stat) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          title: Text(
            "$statName Details",
            style: const TextStyle(color: Colors.white),
          ),
          content: Text(
            'Current: ${stat.currentValue}\nMax: ${stat.maxValue}',
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              child: const Text('Close', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 20, 35), // Dark background
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
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Avatar in the center standing on a pedestal
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  left: 170,
                  top: 150,
                  child: Column(
                    children: [
                      // Wrap GameWidget in a Container with constraints
                      SizedBox(
                        width: 300, // Set a specific width
                        height: 300, // Set a specific height
                        child: widget.game,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                // Stats around avatar
                Positioned(
                  top: 50,
                  left: 16,
                  child: statCard(
                      'XP', PlayerStats.getEXP, Colors.blue, Icons.auto_awesome,
                      () {
                    _showStatDetail(context, 'XP', PlayerStats.getEXP);
                  }),
                ),
                Positioned(
                  top: 50,
                  left: 16,
                  child: statCard(
                      'XP', PlayerStats.getEXP, Colors.blue, Icons.auto_awesome,
                      () {
                    _showStatDetail(context, 'XP', PlayerStats.getEXP);
                  }),
                ),
                Positioned(
                  top: 50,
                  right: 16,
                  child: statCard('HP', PlayerStats.getHP, Colors.greenAccent,
                      Icons.favorite, () {
                    _showStatDetail(context, 'HP', PlayerStats.getHP);
                  }),
                ),
                Positioned(
                  top: 170,
                  left: 16,
                  child: statCard('Intelligence', PlayerStats.getINT,
                      Colors.purpleAccent, Icons.psychology, () {
                    _showStatDetail(
                        context, 'Intelligence', PlayerStats.getINT);
                  }),
                ),
                Positioned(
                  top: 170,
                  right: 16,
                  child: statCard('Strength', PlayerStats.getSTR,
                      Colors.redAccent, Icons.fitness_center, () {
                    _showStatDetail(context, 'Strength', PlayerStats.getSTR);
                  }),
                ),
                Positioned(
                  bottom: 30,
                  right: 16,
                  child: statCard('Stamina', PlayerStats.getSTA,
                      Colors.orangeAccent, Icons.directions_run, () {
                    _showStatDetail(context, 'Stamina', PlayerStats.getSTA);
                  }),
                ),
              ],
            ),
          ),
          // Button to challenge boss
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                widget.game.game?.detach();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // to do
                    builder: (context) => BattleArena(
                      strength: PlayerStats.getSTR.currentValue,
                      intelligence: PlayerStats.getINT.currentValue,
                      stamina: PlayerStats.getSTA.currentValue,
                      hp: PlayerStats.getHP.currentValue,
                      level: PlayerStats.level, 
                      selectedAvatar: widget.selectedAvatar,
                      avatarName: widget.avatarName,
                      avatar: widget.game,
                    ),
                  ),
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
                'Challenge the boss!',
                style: TextStyle(
                    fontSize: 23, color: Color.fromARGB(255, 21, 202, 27)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
