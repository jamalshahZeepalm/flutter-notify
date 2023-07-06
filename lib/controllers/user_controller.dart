import 'package:flutter/material.dart';
import 'package:flutter_notifcationapp/Repository/user_repo.dart';
import 'package:flutter_notifcationapp/controllers/auth_controller.dart';
import 'package:flutter_notifcationapp/controllers/notifications_controller.dart';
import 'package:flutter_notifcationapp/controllers/post_controller.dart';
import 'package:flutter_notifcationapp/model/user_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  Rx<UserModel?> _userModel = Rx<UserModel?>(null);
  UserModel? get user => _userModel.value;

  UserRepository _userRepo = UserRepository();
  @override
  void onInit() {
    _userModel
        .bindStream(_userRepo.userStream(Get.find<AuthController>().user!.uid));
    super.onInit();
  }

  @override
  void onClose() {
    Get.delete<PostController>();
    // _userModel.close();
    Get.delete<UserController>();
    Get.delete<NotificationController>();

    super.onClose();
  }

  @override
  void onReady() {
    Get.put(PostController());
    Get.put(NotificationController());
    super.onReady();
  }
}
