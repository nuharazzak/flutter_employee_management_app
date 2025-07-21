class Task {
  final String name;
  final DateTime dueDate;
  final String priority;
  final String status;

  Task({
    required this.name,
    required this.dueDate,
    required this.priority,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      name: json['name'],
      dueDate: DateTime.parse(json['dueDate']),
      priority: json['priority'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
      'status': status,
    };
  }
}
