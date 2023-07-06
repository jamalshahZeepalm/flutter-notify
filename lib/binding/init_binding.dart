import 'package:flutter_notifcationapp/controllers/post_controller.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/notifications_controller.dart';
import '../controllers/user_controller.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<UserController>(() => UserController());
    Get.lazyPut<PostController>(() => PostController());
    Get.lazyPut<NotificationController>(() => NotificationController());
  }
}
