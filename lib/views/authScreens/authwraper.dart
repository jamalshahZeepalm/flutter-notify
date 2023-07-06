import 'package:flutter/material.dart';
import 'package:flutter_notifcationapp/controllers/auth_controller.dart';
import 'package:flutter_notifcationapp/controllers/notifications_controller.dart';
import 'package:flutter_notifcationapp/controllers/post_controller.dart';
import 'package:flutter_notifcationapp/controllers/user_controller.dart';
import 'package:flutter_notifcationapp/views/admin_dashboard.dart';
import 'package:flutter_notifcationapp/views/authScreens/login_screen.dart';
import 'package:flutter_notifcationapp/views/user_dashbaord.dart';
import 'package:get/get.dart';

class AuthWrappr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find<AuthController>();
    return Obx(() {
      if (authController.user == null) {
        return const LoginScreen();
      } else {
        return GetX<UserController>(
            init: UserController(),
            builder: (uc) {
              if (uc.user == null) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                if (uc.user!.userType == 'Admin') {
                  return const AdminScreen();
                } else {
                  return const UserScreen();
                }
              }
            });
      }
    });
  }
}
