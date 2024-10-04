import 'package:flutter/material.dart';
import 'local_data_storage.dart';
// Import the file that contains the Stat class

class BattleArena extends StatefulWidget {
  final int strength;
  final int intelligence;
  final int stamina;
  final int hp;
  final int level;

  const BattleArena({
    super.key,
    required this.strength,
    required this.intelligence,
    required this.stamina,
    required this.hp,
    required this.level,
  });

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Boss Battle',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Your total stats: $totalPlayerStats',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Boss HP: $bossHP',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
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
              child: const Text('Battle'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Return to the previous screen
              },
              child: const Text('Exit Arena'),
            ),
          ],
        ),
      ),
    );
  }
}
