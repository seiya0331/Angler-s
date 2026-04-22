import 'package:flutter/material.dart';
import '../data/post_repository.dart';
import '../domain/post.dart';

class PostListItem extends StatelessWidget {
  final Post post;
  final String currentUserId;
  final PostRepository postRepository;

  const PostListItem({
    super.key,
    required this.post,
    required this.currentUserId,
    required this.postRepository,
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
        subtitle: Text('${post.content}\nいいね: ${post.likesCount}'),
        isThreeLine: true,
        trailing: currentUserId.isEmpty
            ? const Icon(Icons.favorite_border)
            : StreamBuilder<bool>(
                stream: postRepository.watchIsLiked(
                  postId: post.id,
                  userId: currentUserId,
                ),
                builder: (context, snapshot) {
                  final isLiked = snapshot.data ?? false;
                  return IconButton(
                    onPressed: () async {
                      await postRepository.toggleLike(
                        postId: post.id,
                        userId: currentUserId,
                      );
                    },
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : null,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
