import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/post.dart';

class PostRepository {
  final _db = FirebaseFirestore.instance;

  Future<void> addPost(Post post) async {
    await _db.collection('posts').add({
      ...post.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
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

  Stream<bool> watchIsLiked({
    required String postId,
    required String userId,
  }) {
    return _db
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  Future<void> toggleLike({
    required String postId,
    required String userId,
  }) async {
    final postRef = _db.collection('posts').doc(postId);
    final likeRef = postRef.collection('likes').doc(userId);

    await _db.runTransaction((transaction) async {
      final postSnapshot = await transaction.get(postRef);
      final likeSnapshot = await transaction.get(likeRef);
      final postData = postSnapshot.data() ?? <String, dynamic>{};
      final currentLikes = (postData['likesCount'] as int?) ?? 0;

      if (likeSnapshot.exists) {
        transaction.delete(likeRef);
        transaction.update(postRef, {
          'likesCount': currentLikes > 0 ? currentLikes - 1 : 0,
        });
      } else {
        transaction.set(likeRef, {
          'userId': userId,
          'createdAt': FieldValue.serverTimestamp(),
        });
        transaction.update(postRef, {
          'likesCount': currentLikes + 1,
        });
      }
    });
  }
}
