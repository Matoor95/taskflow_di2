import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskflow_di2/models/task_model.dart';

class TaskService {
  final _db = FirebaseFirestore.instance;
  final String _collection = 'tasks';
  // Stream temps reel des taches de l'utilisateur
  Stream<List<Task>> getTasklsStream(String userId) {
    return _db
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromFirestore(doc.id, doc.data()))
            .toList());
  }
   // Ajouter une tâche
  Future<void> addTask(String title, String userId) async {
    await _db.collection(_collection).add({
      'title': title,
      'done': false,
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // cocher / decocher 
  Future < void> toggleTask( String taskId, bool currentValue) async{

    await _db.collection(_collection).doc(taskId).update({
      'done':!currentValue
    });

  }
  // modifier le titre
  Future < void>  updateTitle( String taskId, String newTitle) async{
    await _db.collection(_collection).doc(taskId).update(
      {
        'title':newTitle
      }
    );
  }
  // supprimer 
  Future<void> deleteTask(String taskId) async{
    await _db.collection(_collection).doc(taskId).delete();
  }
}
