import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserRepository {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUser(UserModel user) async {
    await usersCollection.doc(user.id).set(user.toMap());
  }

  Stream<List<UserModel>> getUsersStream() {
    return usersCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }
}
