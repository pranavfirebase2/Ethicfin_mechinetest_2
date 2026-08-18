import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/task_model.dart';

class RemoteTaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String collectionName = 'tasks';

  CollectionReference get _tasksCollection => _firestore.collection(collectionName);

  Future<List<Task>> fetchAllTasks() async {
    try {
      final snapshot = await _tasksCollection.get();
      return snapshot.docs.map((doc) {
        return Task.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch tasks from Firestore: $e');
    }
  }

  Future<void> saveTask(Task task) async {
    try {
      await _tasksCollection.doc(task.id).set(task.toJson());
    } catch (e) {
      throw Exception('Failed to save task to Firestore: $e');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _tasksCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete task from Firestore: $e');
    }
  }
}
