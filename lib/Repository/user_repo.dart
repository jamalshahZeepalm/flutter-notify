import 'dart:developer';

import 'package:flutter_notifcationapp/Services/database_helper.dart';
import 'package:get/get.dart';

import '../model/user_model.dart';

class UserRepository {
  DatabaseService _databaseService = DatabaseService();

  Future<void> createUser({required UserModel user}) async {
    try {
      log('${user.token}token before create user');
      await _databaseService.usersCollection.doc(user.uid).set(user);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Stream<UserModel> userStream(String uid) {
    return _databaseService.usersCollection
        .doc(uid)
        .snapshots()
        .map((event) => event.data()!);
  }
}
