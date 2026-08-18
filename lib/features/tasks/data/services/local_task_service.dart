import 'package:hive/hive.dart';
import '../../domain/models/task_model.dart';

class LocalTaskService {
  static const String boxName = 'tasksBox';

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskAdapter());
    }
    await Hive.openBox<Task>(boxName);
  }

  Box<Task> get _box => Hive.box<Task>(boxName);

  List<Task> getAllTasks() {
    return _box.values.toList();
  }

  Task? getTask(String id) {
    try {
      return _box.values.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveTask(Task task) async {
    await _box.put(task.id, task);
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final Map<String, Task> tasksMap = {
      for (var task in tasks) task.id: task
    };
    await _box.putAll(tasksMap);
  }

  Future<void> deleteTask(String id) async {
    await _box.delete(id);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}
