import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String priority;

  @HiveField(4)
  final DateTime dueDate;

  @HiveField(5)
  final bool isCompleted;

  @HiveField(6)
  final DateTime createdDate;

  @HiveField(7)
  bool isSynced;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
    this.isCompleted = false,
    required this.createdDate,
    this.isSynced = false,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? priority,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? createdDate,
    bool? isSynced,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdDate: createdDate ?? this.createdDate,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
      'createdDate': createdDate.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      priority: json['priority'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdDate: DateTime.parse(json['createdDate'] as String),
      isSynced: true,
    );
  }
}
