import 'package:flutter/material.dart';

class QuestDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quest Details'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text( // here information can be written
              'This is the quest details page where you can provide more information.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          
          ],
        ),
      ),
    );
  }
}
