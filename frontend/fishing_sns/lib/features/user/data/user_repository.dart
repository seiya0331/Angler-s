import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/user.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> upsertUser(AppUser user) async {
    final ref = _db.collection('users').doc(user.id);
    final snapshot = await ref.get();

    final payload = <String, dynamic>{
      'email': user.email,
      'name': user.name,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (!snapshot.exists) {
      payload['createdAt'] = FieldValue.serverTimestamp();
    }

    await ref.set(payload, SetOptions(merge: true));
  }

  Future<AppUser?> fetchUser(String userId) async {
    final snapshot = await _db.collection('users').doc(userId).get();
    if (!snapshot.exists) {
      return null;
    }

    final data = snapshot.data() ?? <String, dynamic>{};
    final email = (data['email'] as String?) ?? '';
    final name = (data['name'] as String?) ?? '';
    if (email.isEmpty) {
      return null;
    }

    return AppUser(
      id: snapshot.id,
      email: email,
      name: name,
    );
  }
}
