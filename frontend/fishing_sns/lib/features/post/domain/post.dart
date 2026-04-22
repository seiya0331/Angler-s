class Post {
  final String id;
  final String userId;
  final String title;
  final String content;
  final int likesCount;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    this.likesCount = 0,
  });

  factory Post.fromFirestore(String id, Map<String, dynamic> data) {
    final likes = data['likesCount'];
    return Post(
      id: id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      likesCount: likes is num ? likes.toInt() : 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'content': content,
      'likesCount': likesCount,
      'createdAt': DateTime.now().toUtc(),
    };
  }
}
