import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notifcationapp/binding/init_binding.dart';
import 'package:flutter_notifcationapp/controllers/notifications_controller.dart';
import 'package:flutter_notifcationapp/firebase_options.dart';
import 'package:flutter_notifcationapp/views/authScreens/authwraper.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessaging);

  runApp(MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundMessaging(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  log(message.notification!.title.toString());
  NotificationController notificationController = NotificationController();

 
  notificationController.showNotification(
    message: message,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialBinding: InitBinding(),
        home: AuthWrappr());
  }
}
