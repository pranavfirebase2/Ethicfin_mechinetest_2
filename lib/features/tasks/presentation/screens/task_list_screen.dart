import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/models/task_model.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../core/widgets/common_background.dart';
import '../providers/task_provider.dart';
import 'add_task_screen.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  String searchQuery = '';
  String filter = 'All';

  @override
  Widget build(BuildContext context) {
    final allTasks = ref.watch(taskProvider);
    
    var filteredTasks = allTasks;
    if (searchQuery.isNotEmpty) {
      filteredTasks = filteredTasks.where((t) => 
        t.title.toLowerCase().contains(searchQuery.toLowerCase()) || 
        t.description.toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }
    
    if (filter == 'Completed') {
      filteredTasks = filteredTasks.where((t) => t.isCompleted).toList();
    } else if (filter == 'Pending') {
      filteredTasks = filteredTasks.where((t) => !t.isCompleted).toList();
    } else if (filter == 'High Priority') {
      filteredTasks = filteredTasks.where((t) => t.priority.toLowerCase() == 'high').toList();
    }

    return CommonBackground(
      title: 'My Tasks',
      actions: const [],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search tasks...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        searchQuery = val;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: PopupMenuButton<String>(
                    icon: const Icon(Icons.filter_list, color: AppTheme.primaryColor),
                    tooltip: 'Filter Tasks',
                    onSelected: (val) {
                      setState(() {
                        filter = val;
                      });
                    },
                    itemBuilder: (context) => [
                      'All',
                      'Completed',
                      'Pending',
                      'High Priority'
                    ].map((e) => PopupMenuItem(value: e, child: Text(e))).toList(),
                  ),
                ),
              ],
            ),
          ),
          if (filter != 'All')
            Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  label: Text('Filter: $filter', style: const TextStyle(fontSize: 12)),
                  onDeleted: () {
                    setState(() {
                      filter = 'All';
                    });
                  },
                ),
              ),
            ),
          Expanded(
            child: filteredTasks.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return _buildTaskCard(context, ref, task);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
        },
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Task', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, WidgetRef ref, Task task) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                      try {
                        await ref.read(taskProvider.notifier).toggleTaskCompletion(task);
                        if (context.mounted) SnackBarUtils.showSuccess(context, task.isCompleted ? 'Task marked as pending' : 'Task marked as completed!');
                      } catch (e) {
                        if (context.mounted) SnackBarUtils.showError(context, 'Failed to update status.');
                      }
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: task.isCompleted ? AppTheme.secondaryColor : Colors.grey.shade400,
                          width: 2,
                        ),
                        color: task.isCompleted ? AppTheme.secondaryColor : Colors.transparent,
                      ),
                      child: task.isCompleted
                          ? const Icon(Icons.check, size: 16, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                color: task.isCompleted ? Colors.grey : AppTheme.textPrimary,
                                fontSize: 18,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          task.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: task.isCompleted ? Colors.grey.shade400 : AppTheme.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  _buildPriorityBadge(task.priority),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: _getDueDateColor(task)),
                      const SizedBox(width: 6),
                      Text(
                        'Due: ${DateFormat('MMM dd, yyyy').format(task.dueDate)}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _getDueDateColor(task),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        task.isSynced ? Icons.cloud_done : Icons.cloud_upload_outlined,
                        size: 14,
                        color: task.isSynced ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        task.isSynced ? 'Synced' : 'Sync Pending',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: task.isSynced ? Colors.green : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(String priority) {
    Color color;
    switch (priority.toLowerCase()) {
      case 'high':
        color = AppTheme.priorityHigh;
        break;
      case 'medium':
        color = AppTheme.priorityMedium;
        break;
      case 'low':
      default:
        color = AppTheme.priorityLow;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        priority.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Color _getDueDateColor(Task task) {
    if (task.isCompleted) return Colors.grey;
    if (task.dueDate.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      return AppTheme.priorityHigh;
    }
    return AppTheme.textSecondary;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_turned_in_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'No tasks yet!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the + button to add a new task.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
