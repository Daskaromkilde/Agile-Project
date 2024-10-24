import 'package:first_app/battle_arena.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:first_app/playerStats.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

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
  bool canChallengeBoss = true;
  int secondsUntilNextChallenge = 0;
  Timer? timer;

  @override
  void initState(){
    super.initState();
    _checkChallengeAvailability();
  }

  @override
  void dispose(){
    timer?.cancel();
    super.dispose();
  }

  void _checkChallengeAvailability() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? lastVictoryTime = prefs.getInt('lastVictoryTime');

    if (lastVictoryTime != null) {
      int currentTime = DateTime.now().millisecondsSinceEpoch;
      int elapsedTime = currentTime - lastVictoryTime;

      // Check if 24 hours have passed (24 * 60 * 60 * 1000 milliseconds)
      if (elapsedTime < 86400000) {
        setState(() {
          canChallengeBoss = false;
          secondsUntilNextChallenge = (86400000 - elapsedTime) ~/ 1000;
        });

        // Start a countdown timer
        timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
          setState(() {
            secondsUntilNextChallenge--;
            if (secondsUntilNextChallenge <= 0) {
              canChallengeBoss = true;
              timer?.cancel();
            }
          });
        });
      }
    }
  }

    String _formatTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  void increaseStat(Stat stat, int amount) {
    setState(() {
      stat.increase(amount);  
    });
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
    body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('images/UIbackground.png'), // Background image
          fit: BoxFit.cover,
          alignment: const Alignment(0.0, -0.5), // Adjust alignment to move image up
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5), // Semi-transparent black overlay
            BlendMode.darken, // Blend mode
          ),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          // Avatar in the center standing on a pedestal
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  left: 0,
                  right: 0,
                  top: 150,
                  child: Column(
                    children: [
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
                  //XP
                  bottom: 30,
                  right: 0,
                  left: 0,
                  child: statCard(
                      'XP', PlayerStats.getEXP, Colors.blue, Icons.auto_awesome,
                      () {
                    _showStatDetail(context, 'XP', PlayerStats.getEXP);
                  }),
                ),
                Positioned(
                  // HP
                  bottom: 150,
                  left: 16,
                  child: statCard('HP', PlayerStats.getHP, Colors.greenAccent,
                      Icons.favorite, () {
                    _showStatDetail(context, 'HP', PlayerStats.getHP);
                  }),
                ),
                Positioned(
                  //INT
                  bottom: 30,
                  left: 16,
                  child: statCard('Intelligence', PlayerStats.getINT,
                      Colors.purpleAccent, Icons.psychology, () {
                    _showStatDetail(
                        context, 'Intelligence', PlayerStats.getINT);
                  }),
                ),
                Positioned(
                  //STR
                  bottom: 150,
                  right: 16,
                  child: statCard('Strength', PlayerStats.getSTR,
                      Colors.redAccent, Icons.fitness_center, () {
                    _showStatDetail(context, 'Strength', PlayerStats.getSTR);
                  }),
                ),
                Positioned(
                  // STAMINA
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
    onPressed: canChallengeBoss
      ? () async {
          widget.game.game?.detach();

          // Navigate to BattleArena and wait for the result
          var result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BattleArena(
                selectedAvatar: widget.selectedAvatar,
                avatarName: widget.avatarName,
                avatar: widget.game,
              ),
            ),
          );

          // Check if the result is true (player won), and refresh the state
          if (result == true) {
            _checkChallengeAvailability();  // Refresh the button state immediately
          }
        }
      : null,  // Disable the button if not allowed
    style: ElevatedButton.styleFrom(
      backgroundColor: canChallengeBoss
          ? const Color.fromARGB(255, 2, 11, 41)
          : Colors.grey,  // Change color when disabled
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 15,
      ),
    ),
    child: canChallengeBoss
        ? const Text(
            'Challenge the boss!',
            style: TextStyle(
                fontSize: 23, color: Color.fromARGB(255, 21, 202, 27)),
          )
        : Text(
            'Wait ${(secondsUntilNextChallenge ~/ 3600).toString().padLeft(2, '0')}:'
            '${((secondsUntilNextChallenge % 3600) ~/ 60).toString().padLeft(2, '0')}:'
            '${(secondsUntilNextChallenge % 60).toString().padLeft(2, '0')}',
            style: const TextStyle(
                fontSize: 23, color: Colors.redAccent),
          ),
          ),
        )
        ],
      ),
    ),
  );
}
}
