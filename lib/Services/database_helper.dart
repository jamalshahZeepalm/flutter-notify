import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_notifcationapp/model/post_model.dart';
import 'package:flutter_notifcationapp/model/user_model.dart';

class DatabaseService 
{
  final _firestore = FirebaseFirestore.instance;
  
    CollectionReference<UserModel?> get usersCollection => _firestore
          .collection('Users')
          .withConverter(fromFirestore: (snapshot, option) {
        return snapshot.exists ? UserModel.fromMap(snapshot.data()!) : null;
      }, toFirestore: (user, option) {
        return user!.toMap();
      });
    CollectionReference<PostModel?> get postCollection =>
      _firestore.collection('Posts').withConverter(
        fromFirestore: (snapshot, options) {
          return snapshot.exists ? PostModel.fromMap(snapshot.data()!) : null;
        },
        toFirestore: (value, options) {
          return value!.toMap();
        },
      );
}