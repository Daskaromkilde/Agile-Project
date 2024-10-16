import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveTask(String title, bool isCompleted) async {
    await _db.collection('tasks').add({
      'title': title,
      'isCompleted': isCompleted,
    });
  }

  Future<List<Map<String, dynamic>>> fetchTasks() async {
    QuerySnapshot snapshot = await _db.collection('tasks').get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<void> saveLevel(String userId, int level) async {
    await _db.collection('leaderboard').doc(userId).set({
      'level': level,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Map<String, dynamic>>> fetchLeaderboard() async {
    QuerySnapshot snapshot = await _db
        .collection('leaderboard')
        .orderBy('score', descending: true)
        .limit(10)
        .get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}
