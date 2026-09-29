class Todo {
  const Todo({
    required this.id,
    required this.title,
    required this.done,
    required this.createdAt,
  });

  final int id;
  final String title;
  final bool done;
  final DateTime createdAt;

  Todo copyWith({String? title, bool? done}) {
    return Todo(
      id: id,
      title: title ?? this.title,
      done: done ?? this.done,
      createdAt: createdAt,
    );
  }
}
