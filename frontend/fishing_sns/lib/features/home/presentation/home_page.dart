import 'package:flutter/material.dart';
import '../../../core/widgets/loading_view.dart';
import '../../auth/data/auth_repository.dart';
import '../../post/data/post_repository.dart';
import '../../post/domain/post.dart';
import '../../post/presentation/post_list_item.dart';
import '../../post/presentation/post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authRepository = AuthRepository();
  final postRepository = PostRepository();

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
              authRepository.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<List<Post>>(
        stream: postRepository.getPosts(),
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
            return const LoadingView();
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
              return PostListItem(post: posts[index]);
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
