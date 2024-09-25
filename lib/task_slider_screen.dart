import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'quest_info_screen.dart';
import 'task_selection_screen.dart';

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
Widget build(BuildContext context) => Scaffold(
  appBar: AppBar(
    title: const Text('Choose your preference of tasks!'),
  ),
  body: SliderTheme(
    data: const SliderThemeData(
      activeTickMarkColor: Colors.transparent,
      inactiveTickMarkColor: Colors.transparent,
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 600,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space the children evenly
              children: [
                const Text('Int'), // Text on the left
                Expanded( // Use Expanded to make the Slider take all available space
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
                const Text('Str'), // Text on the right
              ],
            ),
          ),
        ],
      ),
    ),
  ),
  floatingActionButton: FloatingActionButton(
    onPressed: proceedToQuestInfoScreen,
    child: const Icon(Icons.arrow_forward),
  ),
);




}