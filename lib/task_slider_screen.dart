import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'quest_info_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class taskSliderScreen extends StatefulWidget {
  final String selectedAvatar;
  final String avatarName;
  final GameWidget game;
  final List<QuestTask> tasks;
  final double taskDiff;

  const taskSliderScreen(
      {super.key,
      required this.selectedAvatar,
      required this.avatarName,
      required this.game,
      required this.tasks,
      required this.taskDiff
      });

  @override
  // ignore: library_private_types_in_public_api
  _taskSliderScreenState createState() => _taskSliderScreenState();
}

class _taskSliderScreenState extends State<taskSliderScreen> {
  List<QuestTask> tasks = [];
  final labels = ['0', '25', '50', '75', '100'];
  final double min = 0;
  final double max = 4;
  final divisions = 4;
  double taskCategory = 50; // Startvalue of the slider

  @override
  void initState() {
    super.initState();
    tasks = widget.tasks;
  }

  void proceedToQuestInfoScreen() {
    print('Slider value: $taskCategory'); // debug print
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestInfoScreen(
          selectedAvatar: widget.selectedAvatar,
          tasks: tasks,
          avatarName: widget.avatarName,
          game: widget.game,
          taskCategory: taskCategory,
          taskDifficulty: widget.taskDiff
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double thumbRadius = 14;
    const double tickMarkRadius = 12;
    const int divisions = 4; // Number of divisions in the slider

    final List<String> tickLabels = [
      'Only Education', // Label for tick mark 0
      'In Between', // Label for tick mark 1
      'Balanced', // Label for tick mark 2
      'In Between', // Label for tick mark 3
      'Only Physical' // Label for tick mark 4
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choose your preference of tasks!',
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
            image: AssetImage(
                'assets/images/Sliderbackground.png'), // Background image
            fit: BoxFit.cover,
            alignment:
                Alignment(0.0, -0.9), // Adjust alignment to move image up
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
                        Text(
                          'Int',
                          style: GoogleFonts.medievalSharp(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            value: taskCategory,
                            min: 0,
                            max: 100,
                            divisions: divisions,
                            label: taskCategory.round().toString(),
                            onChanged: (value) => setState(() {
                              taskCategory = value;
                            }),
                          ),
                        ),
                        Text(
                          'Str',
                          style: GoogleFonts.medievalSharp(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
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
