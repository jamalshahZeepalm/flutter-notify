import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_notifcationapp/Repository/user_repo.dart';
import 'package:flutter_notifcationapp/Services/database_helper.dart';
import 'package:flutter_notifcationapp/controllers/auth_controller.dart';
import 'package:flutter_notifcationapp/controllers/user_controller.dart';
import 'package:flutter_notifcationapp/model/user_model.dart';

import 'package:flutter_notifcationapp/views/admin_dashboard.dart';
import 'package:flutter_notifcationapp/views/authScreens/login_screen.dart';
import 'package:flutter_notifcationapp/views/user_dashbaord.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthRepo {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  UserRepository userRepository = UserRepository();
  DatabaseService databaseService = DatabaseService();
  // signup({
  //   required String userType,
  //   required String password,
  //   required String email,
  //   required String name,
  // }) async {
  //   try {
  //     UserCredential userCredential =
  //         await _firebaseAuth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     Hive.box('box').put('userType', userType);
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userCredential.user!.uid)
  //         .set({
  //       'name': name,
  //       'email': email,
  //       'userType': userType,
  //     }).then((value) {
  //       String userType = Hive.box('box').get(
  //             'userType',
  //           ) ??
  //           '';
  //       if (userType.toString() == 'User') {
  //         Get.off(() => const UserScreen());
  //       } else {

  //          Get.off(() =>  const AdminScreen());
  //       }
  //     });
  //     // Navigate to home screen on successful signup
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //      Get.snackbar('Error', 'The password provided is too weak.');
  //     } else if (e.code == 'email-already-in-use') {
  //        Get.snackbar('Error', 'The account already exists for that email.');
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //   }
  // }

  Future<void> signUp({
    required UserModel userModel,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: userModel.email, password: password);
    userModel.uid = _firebaseAuth.currentUser!.uid;

    await userRepository.createUser(user: userModel);

    Get.back();
    Get.back();
  }

  Future<void> signIn(String userNameOrEmail, String password) async {
    // if (kDebugMode) {
    //   print("userNameOrEmail: $userNameOrEmail");
    // }
    // if (kDebugMode) {
    //   print("password: $password");
    // }
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: userNameOrEmail, password: password);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> signOut() async {
    log(Get.find<AuthController>().user!.uid);
    await databaseService.usersCollection
        .doc(Get.find<AuthController>().user!.uid)
        .update({
      'token': ' ',
    });

    await _firebaseAuth.signOut();
  }
}
