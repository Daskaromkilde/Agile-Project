import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'quest_info_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class DifficultySliderScreen extends StatefulWidget {
  final String selectedAvatar;
  final String avatarName;
  final GameWidget game;
  final List<QuestTask> tasks;
  final double taskCategory;

  const DifficultySliderScreen(
      {super.key,
      required this.avatarName,
      required this.selectedAvatar,
      required this.game,
      required this.tasks,
      required this.taskCategory});

  @override
  _DifficultySliderScreenState createState() => _DifficultySliderScreenState();
}

class _DifficultySliderScreenState extends State<DifficultySliderScreen> {
  List<QuestTask> tasks = [];
  double DifficultySlider = 50;

  @override
  void initState() {
    super.initState();
    tasks = widget.tasks;
  }

  void proceedToQuestInfoScreen() {
    print(
        'taskCategory value: $widget.taskCategory'); // debug taskCategory value
    print('Difficulty value: $DifficultySlider'); // debug difficulty value
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestInfoScreen(
          selectedAvatar: widget.selectedAvatar,
          tasks: tasks,
          avatarName: widget.avatarName,
          game: widget.game,
          taskCategory: widget.taskCategory,
          taskDifficulty: DifficultySlider,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double thumbRadius = 14;
    const double tickMarkRadius = 12;
    const int divisions = 2; // Number of divisions in the slider

    final List<String> tickLabels = [
      'Easy', // Label for tick mark 0
      'Medium', // Label for tick mark 1
      'Hard', // Label for tick mark 2
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choose Difficulty!',
          style: GoogleFonts.medievalSharp(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        // Add background image
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Cave.png'), // Background image
            fit: BoxFit.cover,
            alignment:
                Alignment(0.0, -0.5), // Adjust alignment to move image up
          ),
        ),
        child: Stack(
          children: [
            // Black overlay with 30% opacity
            Container(
              color: Colors.black.withOpacity(0.5),
            ),
            // Centered Slider background
            SliderTheme(
              data: const SliderThemeData(
                trackHeight: 12,
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: thumbRadius,
                  disabledThumbRadius: thumbRadius,
                ),
                rangeThumbShape: RoundRangeSliderThumbShape(
                  enabledThumbRadius: thumbRadius,
                  disabledThumbRadius: thumbRadius,
                ),
                tickMarkShape: RoundSliderTickMarkShape(
                  tickMarkRadius: tickMarkRadius,
                ),
                inactiveTickMarkColor: Color.fromARGB(255, 57, 57, 57),
                inactiveTrackColor: Color.fromARGB(255, 57, 57, 57),
                activeTickMarkColor: Color.fromARGB(255, 152, 87, 189),
                activeTrackColor: Color.fromARGB(255, 152, 87, 189),
                thumbColor: Color.fromARGB(255, 152, 87, 189),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Create a Row for the labels above the slider
                    SizedBox(
                      width: 700,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(divisions + 1, (index) {
                          return SizedBox(
                            width: 80, // Set a fixed width for labels
                            child: Text(
                              tickLabels[index],
                              style: GoogleFonts.medievalSharp(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(
                        height: 10), // Add some space between labels and slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Slider(
                            value: DifficultySlider,
                            min: 0,
                            max: 100,
                            divisions: divisions,
                            label: DifficultySlider.round().toString(),
                            onChanged: (value) => setState(() {
                              DifficultySlider = value;
                            }),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: proceedToQuestInfoScreen,
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
