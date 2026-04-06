import 'package:flutter/material.dart';
import '../models/post.dart';
import 'post_page.dart';
import '../services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Post> posts = [];
  final auth = AuthService();

  void addPost(Post post) {
    setState(() {
      posts.add(post);
    });
  }

  void goToPostPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostPage(onPost: addPost),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('釣りSNS'),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToPostPage,
        child: const Icon(Icons.add),
      ),
    );
  }
}