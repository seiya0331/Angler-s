import 'package:flutter/material.dart';
import '../domain/post.dart';

class PostListItem extends StatelessWidget {
  final Post post;

  const PostListItem({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: ListTile(
        title: Text(post.title),
        subtitle: Text(post.content),
      ),
    );
  }
}
