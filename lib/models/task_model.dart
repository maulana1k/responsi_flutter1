class Task {
  final int id;
  final String title;
  final String description;
  final String deadline;
  final String createdAt;
  final String updatedAt;

  Task(
    this.id,
    this.createdAt,
    this.updatedAt, {
    required this.title,
    required this.description,
    required this.deadline,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      json['id'] as int,
      json['created_at'] as String,
      json['updated_at'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      deadline: json['deadline'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'deadline': deadline,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
