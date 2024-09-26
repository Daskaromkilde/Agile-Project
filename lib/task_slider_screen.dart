import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'quest_info_screen.dart';
import 'task_selection_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class taskSliderScreen extends StatefulWidget{
  final String selectedAvatar;
  final String avatarName;
  final GameWidget game;
  final List<QuestTask> tasks;

  const taskSliderScreen
  ({
    super.key, 
    required this.selectedAvatar, 
    required this.avatarName, 
    required this.game, 
    required this.tasks
  });

  @override 
  // ignore: library_private_types_in_public_api
  _taskSliderScreenState createState() => _taskSliderScreenState();

}

class _taskSliderScreenState extends State<taskSliderScreen>{
  List<QuestTask> tasks = [];
  double SliderValue = 50;

  @override 
  void initState(){
    super.initState();
    tasks = widget.tasks;
  }


  void proceedToQuestInfoScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestInfoScreen(
          selectedAvatar: widget.selectedAvatar,
          tasks: tasks,
          avatarName: widget.avatarName,
          game: widget.game,
        ),
      ),
    );
  }
@override
Widget build(BuildContext context){
  const double thumbRadius = 14;
  const double tickMarkRadius = 10;

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
        image: AssetImage('assets/images/Sliderbackground.png'), // Background image
        fit: BoxFit.cover,
        alignment: Alignment(0.0, -0.9), // Adjust alignment to move image up
      ),
    ),
    child: Stack(
      children: [
        // Black overlay with 30% opacity
        Container(
          color: Colors.black.withOpacity(0.5),
        ),
        // Centered Slider background
        //      
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
              tickMarkRadius: 10,
            ),
              inactiveTickMarkColor: Color.fromARGB(255,57,57,57),
              inactiveTrackColor: Color.fromARGB(255,57,57,57),
              activeTickMarkColor: Color.fromARGB(255, 152, 87, 189),
              activeTrackColor: Color.fromARGB(255, 152, 87, 189),
              thumbColor: Color.fromARGB(255, 152, 87, 189),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 600,
                  child: Row(
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
                          value: SliderValue,
                          min: 0,
                          max: 100,
                          divisions: 4,
                          label: SliderValue.round().toString(),
                          onChanged: (value) => setState(() {
                            SliderValue = value;
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