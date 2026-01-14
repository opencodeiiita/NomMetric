import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get _usersRef => _db.collection('users');

  Future<void> createUserData(User user) async {
    final DocumentSnapshot doc = await _usersRef.doc(user.uid).get();

    if (!doc.exists) {
      final newUser = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? 'No Name',
        rollNumber: 'Pending', 
        hostel: 'Pending',
        roomNumber: 'Pending',
        createdAt: DateTime.now(),
      );
      await _usersRef.doc(user.uid).set(newUser.toMap());
    }
  }

  // Stream User Data (For Real-time updates on Profile Screen)
  Stream<UserModel> getUserData(String uid) {
    return _usersRef.doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
      } else {
        return UserModel(
          uid: uid, 
          email: '', 
          name: 'Loading...', 
          rollNumber: '', 
          hostel: '', 
          roomNumber: '', 
          createdAt: DateTime.now()
        );
      }
    });
  }
}