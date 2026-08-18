import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../data/services/local_task_service.dart';
import '../../data/services/remote_task_service.dart';
import '../../data/repositories/task_repository.dart';
import '../../domain/models/task_model.dart';

final localTaskServiceProvider = Provider((ref) => LocalTaskService());
final remoteTaskServiceProvider = Provider((ref) => RemoteTaskService());
final connectivityProvider = Provider((ref) => Connectivity());

final taskRepositoryProvider = Provider((ref) {
  final local = ref.watch(localTaskServiceProvider);
  final remote = ref.watch(remoteTaskServiceProvider);
  final connectivity = ref.watch(connectivityProvider);
  return TaskRepository(local, remote, connectivity);
});

class TaskNotifier extends Notifier<List<Task>> {
  late final TaskRepository _repository;

  @override
  List<Task> build() {
    _repository = ref.watch(taskRepositoryProvider);
    _repository.onDataChanged = () {
      _loadTasks();
    };
    return _repository.getLocalTasks();
  }

  void _loadTasks() {
    state = _repository.getLocalTasks();
  }

  Future<void> addTask(Task task) async {
    await _repository.saveTask(task);
    _loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await _repository.saveTask(task);
    _loadTasks();
  }

  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
    _loadTasks();
  }
  
  Future<void> toggleTaskCompletion(Task task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await _repository.saveTask(updatedTask);
    _loadTasks();
  }
}

final taskProvider = NotifierProvider<TaskNotifier, List<Task>>(TaskNotifier.new);
