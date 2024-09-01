import 'dart:convert';

List<Task> taskFromJson(String str) =>
    List<Task>.from(json.decode(str).map((x) => Task.fromJson(x)));

String taskToJson(List<Task> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Task {
  Task({
    this.id,
    required this.title,
    required this.content,
  });

  int? id;
  String title;
  String content;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        title: json["title"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
      };

  Task copy({
    int? id,
    String? title,
    String? content,
  }) =>
      Task(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
      );
}