import 'dart:developer';

import 'package:flutter_notifcationapp/Repository/post_repo.dart';
import 'package:flutter_notifcationapp/controllers/auth_controller.dart';
import 'package:flutter_notifcationapp/controllers/user_controller.dart';
import 'package:flutter_notifcationapp/model/post_model.dart';
import 'package:get/get.dart';

class PostController extends GetxController {
  Rx<List<PostModel>?> _postModel = Rx<List<PostModel>?>([]);
  Rx<List<PostModel>?> _postModel2 = Rx<List<PostModel>?>([]);
  List<PostModel>? get userPostList => _postModel.value;
  List<PostModel>? get adminPostList => _postModel2.value;
  PostRepo postRepo = PostRepo();

  UserController userController = Get.find<UserController>();

  @override
  void onInit() {
    _postModel2.bindStream(postRepo.getPendingPosts());

    _postModel.bindStream(postRepo.getActivePosts());

    log(" post controller uid ${Get.find<AuthController>().user!.uid}");
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    _postModel.close();
    _postModel2.close();
  }
}
