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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 450,
            child: Positioned(

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
          ),
        ],
      ),
    floatingActionButton: FloatingActionButton(
    onPressed: proceedToQuestInfoScreen,
    child: const Icon(Icons.arrow_forward),
  ),
    );

}