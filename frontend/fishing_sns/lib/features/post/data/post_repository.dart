import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/post.dart';

class PostRepository {
  final _db = FirebaseFirestore.instance;

  Future<void> addPost(Post post) async {
    await _db.collection('posts').add(post.toMap());
  }

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
