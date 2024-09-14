import 'package:flutter/material.dart';
import 'package:fluttertest/quest_info_screen.dart';

class AvatarSelectPage extends StatefulWidget {
  @override
  _AvatarSelectPageState createState() => _AvatarSelectPageState();
}

class _AvatarSelectPageState extends State<AvatarSelectPage> {
  // List of avatar image paths
  final List<String> _avatars = [
    'lib/assets/mushu.png', // Replace with your actual image paths
    'lib/assets/dragon.png',
    'lib/assets/egg.png',
    'lib/assets/egg.png'
  ];

  String selectedAvatar = '';

  int _currentIndex = 0;

  void _nextAvatar() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _avatars.length;
    });
  }

  void _previousAvatar() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _avatars.length) % _avatars.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Avatar'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Navigation buttons and character image
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_left, size: 32, color: Colors.white),
                onPressed: _previousAvatar,
              ),
              SizedBox(width: 20),
              Expanded(
                child: Center(
                  child: Image.asset(
                    _avatars[_currentIndex],
                    height: 200,
                    width: 200,
                  ),
                ),
              ),
              SizedBox(width: 20),
              IconButton(
                icon: Icon(Icons.arrow_right, size: 32, color: Colors.white),
                onPressed: _nextAvatar,
              ),
            ],
          ),
          SizedBox(height: 20),

          // Title and description
          Text(
            'Choose Your Avatar',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Select an avatar to represent you in the game. Customize it to match your style and preferences.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 30),

          // Button to confirm selection
          ElevatedButton(
            onPressed: () {
              // Navigate to the QuestInfoScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        QuestInfoScreen(selectedAvatar: selectedAvatar)),
              );
              selectedAvatar = _avatars[_currentIndex];
            },
            child: Text('Confirm Selection'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blueGrey[800],
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
