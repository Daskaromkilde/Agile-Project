import 'package:flutter/material.dart';

class BattleArena extends StatelessWidget {
  const BattleArena({super.key});

  @override
  Widget build(BuildContext context) {
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
              'Boss Battle placeholder',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'ba noobs förlorar på tutorial bossen',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
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
