import 'package:first_app/task_selection_screen.dart';
import 'package:flutter/material.dart';

class AvatarSelectPage extends StatefulWidget {
  const AvatarSelectPage({super.key});

  @override
  _AvatarSelectPageState createState() => _AvatarSelectPageState();
}

class _AvatarSelectPageState extends State<AvatarSelectPage> {
  final List<String> _avatars = [
    'lib/assets/egg.png',
    'lib/assets/mushu.png',
    'lib/assets/dragon.png',
  ];

  String selectedAvatar = 'lib/assets/egg.png';
  int _currentIndex = 0;

  void _nextAvatar() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _avatars.length;
      selectedAvatar = _avatars[_currentIndex];
    });
  }

  void _previousAvatar() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _avatars.length) % _avatars.length;
      selectedAvatar = _avatars[_currentIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Avatar'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon:
                    const Icon(Icons.arrow_left, size: 32, color: Colors.white),
                onPressed: _previousAvatar,
              ),
              const SizedBox(width: 20),
              Image.asset(
                _avatars[_currentIndex],
                height: 200,
                width: 200,
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.arrow_right,
                    size: 32, color: Colors.white),
                onPressed: _nextAvatar,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Choose Your Avatar',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Select an avatar to represent you in the game.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      task_selection_screen(selectedAvatar: selectedAvatar),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blueGrey[800],
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: const Text('Confirm Selection'),
          ),
        ],
      ),
    );
  }
}
