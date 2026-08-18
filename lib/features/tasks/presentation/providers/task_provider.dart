import 'dart:async';
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

class TaskNotifier extends AsyncNotifier<List<Task>> {
  late final TaskRepository _repository;

  @override
  FutureOr<List<Task>> build() async {
    _repository = ref.watch(taskRepositoryProvider);
    _repository.onDataChanged = () {
      _loadTasks();
    };
    
    await Future.delayed(const Duration(milliseconds: 800)); 
    return _fetchSortedTasks();
  }

  List<Task> _fetchSortedTasks() {
    final tasks = _repository.getLocalTasks();
    tasks.sort((a, b) => b.createdDate.compareTo(a.createdDate));
    return tasks;
  }

  Future<void> _loadTasks() async {
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 300)); 
    state = AsyncValue.data(_fetchSortedTasks());
  }

  Future<void> addTask(Task task) async {
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 300));
    await _repository.saveTask(task);
    state = AsyncValue.data(_fetchSortedTasks());
  }

  Future<void> updateTask(Task task) async {
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 300));
    await _repository.saveTask(task);
    state = AsyncValue.data(_fetchSortedTasks());
  }

  Future<void> deleteTask(String id) async {
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 300));
    await _repository.deleteTask(id);
    state = AsyncValue.data(_fetchSortedTasks());
  }
  
  Future<void> toggleTaskCompletion(Task task) async {
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 300));
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await _repository.saveTask(updatedTask);
    state = AsyncValue.data(_fetchSortedTasks());
  }
}

final taskProvider = AsyncNotifierProvider<TaskNotifier, List<Task>>(TaskNotifier.new);
