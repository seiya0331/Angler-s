class Post {
  final String id;
  final String title;
  final String content;

  Post({
    required this.id,
    required this.title,
    required this.content,
  });

  factory Post.fromFirestore(String id, Map<String, dynamic> data) {
    return Post(
      id: id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'createdAt': DateTime.now(),
    };
  }
}
