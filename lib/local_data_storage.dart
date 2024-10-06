import 'package:shared_preferences/shared_preferences.dart';
import 'playerStats.dart';

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
  static const String _bossHP = 'bossHP';
  static const String _avatarlevel = 'avatarlevel';
  static const String _unableTaskKey = 'unableTaskKey';
  static const String _playerstatsKey = 'playerStats';

  Future<void> saveBossHP(int bossHP) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_bossHP, bossHP);
  }

  Future<int> loadBossHP() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_bossHP) ?? 300; // Default boss HP is 300
  }

  Future<void> savePlayerStats() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save each stat separately
    prefs.setInt('exp', PlayerStats.exp.currentValue);
    prefs.setInt('exp_max', PlayerStats.exp.maxValue);
    prefs.setInt('str', PlayerStats.str.currentValue);
    prefs.setInt('str_max', PlayerStats.str.maxValue);
    prefs.setInt('intell', PlayerStats.intell.currentValue);
    prefs.setInt('intell_max', PlayerStats.intell.maxValue);
    prefs.setInt('hp', PlayerStats.hp.currentValue);
    prefs.setInt('hp_max', PlayerStats.hp.maxValue);
    prefs.setInt('sta', PlayerStats.sta.currentValue);
    prefs.setInt('sta_max', PlayerStats.sta.maxValue);

    prefs.setInt('player_level', PlayerStats.level);
  }

  // Load PlayerStats from SharedPreferences
  Future<void> loadPlayerStats() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load each stat separately
    PlayerStats.exp = Stat(
      currentValue: prefs.getInt('exp') ?? 0,
      maxValue: prefs.getInt('exp_max') ?? 10000,
      level: 0, // or load level if necessary
    );
    PlayerStats.str = Stat(
      currentValue: prefs.getInt('str') ?? 0,
      maxValue: prefs.getInt('str_max') ?? 100,
      level: 0,
    );
    PlayerStats.intell = Stat(
      currentValue: prefs.getInt('intell') ?? 0,
      maxValue: prefs.getInt('intell_max') ?? 100,
      level: 0,
    );
    PlayerStats.hp = Stat(
      currentValue: prefs.getInt('hp') ?? 0,
      maxValue: prefs.getInt('hp_max') ?? 100,
      level: 0,
    );
    PlayerStats.sta = Stat(
      currentValue: prefs.getInt('sta') ?? 0,
      maxValue: prefs.getInt('sta_max') ?? 100,
      level: 0,
    );

    PlayerStats.level = prefs.getInt('player_level') ?? 0;
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
      'name': name ?? 'Player',
    };
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
