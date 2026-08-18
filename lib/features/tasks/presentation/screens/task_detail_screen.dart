import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../core/widgets/common_background.dart';
import '../../domain/models/task_model.dart';
import '../providers/task_provider.dart';
import 'add_task_screen.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  bool _isDeleting = false;
  bool _isToggling = false;

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(taskProvider);
    final tasks = asyncState.value ?? [];
    final currentTask = tasks.firstWhere((t) => t.id == widget.task.id, orElse: () => widget.task);

    return CommonBackground(
      title: 'Task Details',
      actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddTaskScreen(taskToEdit: currentTask)),
              );
            },
          ),
          IconButton(
            icon: _isDeleting 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.priorityHigh))
                : const Icon(Icons.delete_outline, color: AppTheme.priorityHigh),
            onPressed: _isDeleting ? null : () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete Task'),
                  content: const Text('Are you sure you want to delete this task? This action cannot be undone.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true), 
                      child: const Text('Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );

              if (confirm != true) return;

              setState(() { _isDeleting = true; });
              try {
                await ref.read(taskProvider.notifier).deleteTask(currentTask.id);
                if (context.mounted) SnackBarUtils.showSuccess(context, 'Task deleted successfully!');
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                if (context.mounted) SnackBarUtils.showError(context, 'Failed to delete task.');
                setState(() { _isDeleting = false; });
              }
            },
          ),
        ],
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildPriorityBadge(currentTask.priority),
                    ],
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: _isToggling ? null : () async {
                      setState(() { _isToggling = true; });
                      try {
                        await ref.read(taskProvider.notifier).toggleTaskCompletion(currentTask);
                        if (context.mounted) SnackBarUtils.showSuccess(context, currentTask.isCompleted ? 'Task marked as pending' : 'Task marked as completed!');
                      } catch (e) {
                        if (context.mounted) SnackBarUtils.showError(context, 'Failed to update status.');
                      } finally {
                        if (mounted) setState(() { _isToggling = false; });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: currentTask.isCompleted ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: currentTask.isCompleted ? Colors.green.withValues(alpha: 0.3) : Colors.orange.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: currentTask.isCompleted ? Colors.green : Colors.orange,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              currentTask.isCompleted ? Icons.check : Icons.hourglass_top,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Current Status',
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                ),
                                Text(
                                  currentTask.isCompleted ? 'Completed' : 'Pending',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: currentTask.isCompleted ? Colors.green.shade700 : Colors.orange.shade800,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Tap to change status',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 10,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: currentTask.isCompleted,
                            activeColor: Colors.green,
                            onChanged: _isToggling ? null : (val) async {
                              setState(() { _isToggling = true; });
                              try {
                                await ref.read(taskProvider.notifier).toggleTaskCompletion(currentTask);
                                if (context.mounted) SnackBarUtils.showSuccess(context, currentTask.isCompleted ? 'Task marked as pending' : 'Task marked as completed!');
                              } catch (e) {
                                if (context.mounted) SnackBarUtils.showError(context, 'Failed to update status.');
                              } finally {
                                if (mounted) setState(() { _isToggling = false; });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildInfoRow(Icons.calendar_today, 'Due Date', DateFormat('MMM dd, yyyy').format(currentTask.dueDate)),
                  const SizedBox(height: 32),
                  const Divider(color: Colors.black12),
                  const SizedBox(height: 24),
                  Text(
                    currentTask.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentTask.description,
                    style: const TextStyle(fontSize: 16, color: AppTheme.textSecondary, height: 1.5),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Created on ${DateFormat('MMM dd, yyyy - hh:mm a').format(currentTask.createdDate)}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary)),
          ],
        ),
      ],
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
        '$priority Priority'.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    );
  }
}

