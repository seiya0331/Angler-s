import 'package:flutter/material.dart';
import '../models/post.dart';

class PostPage extends StatefulWidget {
  final Function(Post) onPost;

  const PostPage({super.key, required this.onPost});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  void submit() {
    final post = Post(
      title: titleController.text,
      content: contentController.text,
    );

    widget.onPost(post);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('投稿')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'タイトル'),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: '内容'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: submit,
              child: const Text('投稿する'),
            ),
          ],
        ),
      ),
    );
  }
}