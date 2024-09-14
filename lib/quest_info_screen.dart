import 'package:flutter/material.dart';
import 'avatar_select_page.dart'; // Import the AvatarSelectPage

class QuestInfoScreen extends StatefulWidget {
  @override
  _QuestInfoScreenState createState() => _QuestInfoScreenState();
}

class _QuestInfoScreenState extends State<QuestInfoScreen> {
  // Boolean values to track whether tasks are completed
  bool _pushUpsDone = false;
  bool _sitUpsDone = false;
  bool _squatsDone = false;
  bool _runDone = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Title section with background and icon
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.blue[800],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, color: Colors.white, size: 28),
                SizedBox(width: 10),
                Text(
                  'QUEST INFO',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // Subtitle section
          Text(
            'Daily Quest - Train to Evolve\nin Game and in Real Life',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 30),

          // Goals list section with checkboxes
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QuestItem(
                title: 'Push-ups',
                progress: '[0/100]',
                isChecked: _pushUpsDone,
                onChanged: (value) {
                  setState(() {
                    _pushUpsDone = value!;
                  });
                },
              ),
              QuestItem(
                title: 'Sit-ups',
                progress: '[0/100]',
                isChecked: _sitUpsDone,
                onChanged: (value) {
                  setState(() {
                    _sitUpsDone = value!;
                  });
                },
              ),
              QuestItem(
                title: 'Squats',
                progress: '[0/100]',
                isChecked: _squatsDone,
                onChanged: (value) {
                  setState(() {
                    _squatsDone = value!;
                  });
                },
              ),
              QuestItem(
                title: 'Run',
                progress: '[0/10KM]',
                isChecked: _runDone,
                onChanged: (value) {
                  setState(() {
                    _runDone = value!;
                  });
                },
              ),
            ],
          ),

          SizedBox(height: 30),

          // Caution text section
          Text(
            'CAUTION! - If the daily quest\nremains incomplete, penalties\nwill be given accordingly.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),

          Spacer(),

          // Button to navigate to AvatarSelectPage
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AvatarSelectPage()),
              );
            },
            child: Text('Go to Avatar Page'),
          ),
        ],
      ),
    );
  }
}

class QuestItem extends StatelessWidget {
  final String title;
  final String progress;
  final bool isChecked;
  final Function(bool?)? onChanged;

  const QuestItem({
    required this.title,
    required this.progress,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                value: isChecked,
                onChanged: onChanged,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Text(
            progress,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
