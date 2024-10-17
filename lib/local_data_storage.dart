import 'package:shared_preferences/shared_preferences.dart';
import 'quest_info_screen.dart';
import 'dart:convert';

class DataStorage {
  
  // This class is NOT finished, missing parts will need to be added -
  // - as the program is developed further, and new features are added.

  // Singleton instance
  // Only one instance of DataStorage can be created
  // Usefull since we access the same data storage from multiple places
  static final DataStorage _dataStorage = DataStorage._internal();

  // factory constructor, returns the singleton instance
  factory DataStorage() {
    return _dataStorage;
  }

  // Internal constructor, only called once for Singleton instance
  DataStorage._internal();

  // Variables to what we want to save locally
  static const String _avatar = 'avatar';
  static const String _name = 'name';
  static const String _xp = 'xp';
  static const String _bosslevel = 'bosslevel';
  static const String _avatarlevel = 'avatarlevel';
  static const String _unableTaskKey = 'unableTaskKey';
  static const String _completeSetup = 'completeSetup';
  static const String _taskList = 'taskList';
  static const String _taskDifficulty = 'taskDifficulty';
  static const String _taskCategory = 'taskCategory';

  Future<void> saveTaskCategory(double taskCategory) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_taskCategory, taskCategory);
  }
  Future<void> saveTaskDifficulty(double taskDifficulty) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_taskDifficulty, taskDifficulty);
  }
  Future<double> loadTaskCategory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_taskCategory) ?? 0.0;
  }
  Future<double> loadTaskDifficulty() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_taskDifficulty) ?? 0.0;
  }
  // Save the avatar/name to local storage
  Future<void> saveAvatarSaveName(String avatar, String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_avatar, avatar);
    await prefs.setString(_name, name);
  }

  // Load avatar/name
  Future<Map<String, String>> loadAvatarSaveName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? avatar = prefs.getString(_avatar);
    final String? name = prefs.getString(_name);
    
    return {
      'avatar': avatar ?? 'necromancer',
      'name'  : name ?? 'Player',
    };
  }

  // Save the XP
  Future<void> saveXP(int xp) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_xp, xp);
  }

  // save boss level
  Future<void> savebosslevel(int bosslevel) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_bosslevel, bosslevel);
  }

  // Load bosslevel
  Future<int?> loadbosslevel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_bosslevel);
  }
  // save unable tasks
  Future<void> saveUnableTasks(List<String> unableTasks) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_unableTaskKey, unableTasks);
  }
  // Load unable tasks
  Future<List<String>> loadUnableTasks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_unableTaskKey) ?? [];
  }

  Future<void> setCompleteSetup(bool completeSetup) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_completeSetup, completeSetup);
  }

  Future<bool> checkCompleteSetup() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_completeSetup) ?? false;
  }

  Future<void> saveTaskList(List<QuestTask> taskList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = taskList.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList(_taskList, jsonList);
  }

  Future<List<QuestTask>> loadTaskList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? jsonTaskList = prefs.getStringList(_taskList);

    if (jsonTaskList != null) {
      // Convert the list of JSON strings back into QuestTask objects
      return jsonTaskList.map((jsonTask) {
        final Map<String, dynamic> taskMap = jsonDecode(jsonTask);
        return QuestTask.fromJson(taskMap);
      }).toList();
    }
    return [];
  }



// In the main class we need to load QuestInfoScreen() but with the correct parameters
// In order to do that we need to store and Load the necessary parameters to extract from storage to 
// currently ive managed to create a way to store the TODO Task list in the local storage
// SelectedAvatar and avatar name is also stored correctly
// TODO: Implement the rest of the parameters, taskDifficulty & taskCategory. 


}
