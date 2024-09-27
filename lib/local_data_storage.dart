import 'package:shared_preferences/shared_preferences.dart';

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

}
