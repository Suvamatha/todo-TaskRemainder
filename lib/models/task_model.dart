class Task {
  final String id;
  final String title;
  final String priority;
  final DateTime? dueDate;
  final bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    this.dueDate,
    this.isDone = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      priority: json['priority'] ?? 'medium',
      dueDate: json['dueDate'] != null ? DateTime.tryParse(json['dueDate']) : null,
      isDone: json['done'] ?? json['isDone'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'priority': priority,
      'dueDate': dueDate?.toIso8601String(),
      'done': isDone,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? priority,
    DateTime? dueDate,
    bool? isDone,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      isDone: isDone ?? this.isDone,
    );
  }
}
