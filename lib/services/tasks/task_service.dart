import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskflow_di2/models/task_model.dart';

class TaskService {
  final _db = FirebaseFirestore.instance;
  final String _collection = 'tasks';

  // Stream temps reel des taches de l'utilisateur
  Stream<List<Task>> getTasksStream(String userId) {
    return _db
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAd', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromFirestore(doc.id, doc.data()))
            .toList());
  }

  // ajouter une tache 

  Future <void> addTask(String title, String userId) async{
    await _db.collection(_collection).add({
      'title':title,
      'done':false,
      'userId':userId,
      'createdAt': FieldValue.serverTimestamp()
    });
  }
}
