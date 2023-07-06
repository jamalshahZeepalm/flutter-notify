import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter_notifcationapp/Services/database_helper.dart';
import 'package:flutter_notifcationapp/controllers/auth_controller.dart';
import 'package:flutter_notifcationapp/model/post_model.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class PostRepo {
  DatabaseService _databaseService = DatabaseService();
  uploadPost({required PostModel postModel}) {
    String random = DateTime.now().millisecondsSinceEpoch.toString();
    if (kDebugMode) {
      log(random);
    }
    postModel.id = random;

    _databaseService.postCollection.doc(random).set(postModel).then((value) {
      if (kDebugMode) {
        print("Post Uploaded");
      }
      Get.back<void>();
    }).catchError(
        (error) => Get.snackbar('error', "Failed to upload post: $error"));
  }

  // get current user posts
  Stream<List<PostModel>?> getActivePosts() {
    return _databaseService.postCollection
        .where('uid', isEqualTo: Get.find<AuthController>().user!.uid)
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()!).toList());
  }

  Stream<List<PostModel>?> getPendingPosts() {
    return _databaseService.postCollection
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()!).toList());
  }

  Future<void> statusChangePost(
      {required var myData, required String status}) async {
    await _databaseService.postCollection.doc(myData.id.toString()).update({
      'title': myData.title.toString(),
      'description': myData.description.toString(),
      'uid': myData.uid.toString(),
      'token': myData.token.toString(),
      'status': status,
    }).then((value) {
      log("Post Status Changed");
    }).catchError((error) => log("Failed to upload post: $error"));
  }
}
