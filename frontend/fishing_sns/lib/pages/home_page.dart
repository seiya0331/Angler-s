import 'package:flutter/material.dart';
import '../models/post.dart';
import 'post_page.dart';
import '../services/auth_service.dart';
import '../services/post_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final auth = AuthService();
  final postService = PostService();

  void goToPostPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PostPage(),
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

      // Firestoreから投稿取得
      body: StreamBuilder<List<Post>>(
        stream: postService.getPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '投稿の読み込みに失敗しました\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('投稿がまだありません'),
            );
          }

          final posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];

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
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: goToPostPage,
        child: const Icon(Icons.add),
      ),
    );
  }
}