class Todo {
  final String id;
  String title;
  bool completed;

  Todo({
    required this.id,
    required this.title,
    this.completed = false,
  });
}