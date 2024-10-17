import 'package:first_app/avatar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'task_selection_screen.dart';
import 'local_data_storage.dart';

class AvatarSelectPage extends StatefulWidget {
  const AvatarSelectPage({super.key});

  @override
  _AvatarSelectPageState createState() => _AvatarSelectPageState();
}

class _AvatarSelectPageState extends State<AvatarSelectPage> {
  final TextEditingController _nameController = TextEditingController();
  late DataStorage _dataStorage;
  // List all the avatars
  final List<String> _avatars = [
    'necromancer', // Necromancer animation
    'fire_warrior', // Fire Warrior animation
    'wind_warrior', // Wind Warrior animation
    'female_knight', // Female Knight animation
    'blue_witch', // Blue Witch animation
  ];

  String selectedAvatar = 'necromancer';
  int _currentIndex = 0;

  // Navigate to the next avatar in the list
  void _nextAvatar() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _avatars.length;
      selectedAvatar = _avatars[_currentIndex];
    });
  }

  @override
  void initState() {
    super.initState();
    _dataStorage = DataStorage();
    _loadSavedData();
    }
  
  Future<void> _loadSavedData() async {
    final savedData = await _dataStorage.loadAvatarSaveName();
    setState(() {
      selectedAvatar = savedData['avatar']!;
      _nameController.text = savedData['name']!;
    });
  }
  // Navigate to the previous avatar in the list
  void _previousAvatar() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _avatars.length) % _avatars.length;
      selectedAvatar = _avatars[_currentIndex];
    });
  }

  // Get the correct avatar widget based on the selected avatar
  GameWidget _getAvatarWidget() {
     return AvatarUtils.getAvatarWidget(selectedAvatar);
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
              SizedBox(
                width: 256,
                height: 256,
                child: _getAvatarWidget(),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30.0),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Enter your avatar name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              String enteredName = _nameController.text;
              _dataStorage.saveAvatarSaveName(selectedAvatar, enteredName);
              _dataStorage.setCompleteSetup(true);

              // Navigate to task selection screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => task_selection_screen(
                    selectedAvatar: selectedAvatar,
                    avatarName: enteredName,
                    game:
                        _getAvatarWidget(), // Get the game object from the widget
                  ),
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
