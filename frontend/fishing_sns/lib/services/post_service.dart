import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post.dart';

class PostService {
  final _db = FirebaseFirestore.instance;

  // 投稿追加
  Future<void> addPost(Post post) async {
    await _db.collection('posts').add(post.toMap());
  }

  // 投稿一覧取得（リアルタイムで更新される）
  Stream<List<Post>> getPosts() {
    return _db
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Post.fromFirestore(doc.id, doc.data());
      }).toList();
    });
  }
}