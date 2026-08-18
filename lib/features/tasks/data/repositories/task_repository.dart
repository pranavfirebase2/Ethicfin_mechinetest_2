import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/local_task_service.dart';
import '../services/remote_task_service.dart';
import '../../domain/models/task_model.dart';


class TaskRepository {
  final LocalTaskService _localService;
  final RemoteTaskService _remoteService;
  final Connectivity _connectivity;
  
  void Function()? onDataChanged;

  TaskRepository(this._localService, this._remoteService, this._connectivity) {
    _initAutoSync();
  }

  void _initAutoSync() {
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) async {
      if (results.contains(ConnectivityResult.mobile) || results.contains(ConnectivityResult.wifi)) {
        await syncPendingTasks();
        onDataChanged?.call();
      }
    });
  }

  List<Task> getLocalTasks() {
    return _localService.getAllTasks();
  }

  Future<void> saveTask(Task task) async {
    task.isSynced = false;
    await _localService.saveTask(task);
    onDataChanged?.call();

    await _syncTask(task);
    onDataChanged?.call();
  }

  Future<void> deleteTask(String id) async {
    await _localService.deleteTask(id);
    onDataChanged?.call();
    
    final connection = await _connectivity.checkConnectivity();
    if (connection.contains(ConnectivityResult.mobile) || connection.contains(ConnectivityResult.wifi)) {
      try {
        await _remoteService.deleteTask(id);
      } catch (e) {
      }
    }
  }

  Future<void> syncPendingTasks() async {
    final tasks = _localService.getAllTasks();
    final pendingTasks = tasks.where((t) => !t.isSynced).toList();

    for (var task in pendingTasks) {
      await _syncTask(task);
    }
    
    try {
      final remoteTasks = await _remoteService.fetchAllTasks();
      for (var task in remoteTasks) {
        task.isSynced = true;
      }
      await _localService.saveTasks(remoteTasks);
    } catch (e) {
    }
  }

  Future<void> _syncTask(Task task) async {
    final connection = await _connectivity.checkConnectivity();
    if (connection.contains(ConnectivityResult.mobile) || connection.contains(ConnectivityResult.wifi)) {
      try {
        await _remoteService.saveTask(task);
        task.isSynced = true;
        await _localService.saveTask(task);
      } catch (e) {
      }
    }
  }
}
