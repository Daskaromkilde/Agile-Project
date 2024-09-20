import 'package:flutter/material.dart';
import 'quest_info_screen.dart';

class AvatarViewPage extends StatefulWidget {
  final String selectedAvatar;
  final String avatarName;

  const AvatarViewPage(
      {super.key, required this.selectedAvatar, required this.avatarName});

  @override
  _AvatarViewPage createState() => _AvatarViewPage();
}

class _AvatarViewPage extends State<AvatarViewPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 6, 38, 64),
        title: const Text('Avatar View',
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.avatarName,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Changed to black for better visibility
              ),
            ),
            Center(
              child: Image.asset(
                widget.selectedAvatar,
                height: 200,
                width: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
