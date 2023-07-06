import 'dart:convert';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notifcationapp/Services/database_helper.dart';
import 'package:flutter_notifcationapp/controllers/auth_controller.dart';
import 'package:flutter_notifcationapp/controllers/user_controller.dart';
import 'package:flutter_notifcationapp/data/const.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NotificationController extends GetxController {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? token;
  DatabaseService db = DatabaseService();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    requsertPermission();
    firebseInit(Get.context!, 'user data initState');
    getToken().then((value) {
      if (kDebugMode) {
        dev.log(value.toString());
      }
      token = value.toString();
      refreshUserToken(token.toString() );
    });
  }

  pushNotificationsSpecificDevice({
    required String token,
    required String title,
    required String body,
  }) async {
    await http.post(
      Uri.parse(apikey),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$authorization',
      },
      body: jsonEncode(<String, dynamic>{
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFACTION_CLICK',
          'status': 'done',
          'body': body,
          'title': title,
          'id': '0'
        },
        'notification': <String, dynamic>{
          'body': body,
          'title': title,
          'andriod_channel_id': 'high_importance_channel'
        },
        'to': token,
      }),
    );
  }

  void requsertPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        dev.log('user permission granted');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        dev.log('user permission provisional granted');
      }
    } else {
      if (kDebugMode) {
        dev.log('user permission done');
      }
    }
  }

  void firebseInit(BuildContext context, String data) {
    FirebaseMessaging.onMessage.listen((massage) {
      if (kDebugMode) {
        dev.log(massage.notification!.title.toString());
      }
      if (kDebugMode) {
        dev.log(massage.notification!.body.toString());
      }
      if (kDebugMode) {
        dev.log(data);
      }
      initLocalNotification(context: context, message: massage);
      showNotification(message: massage);
    });
  }

  void initLocalNotification({
    required BuildContext context,
    required RemoteMessage message,
  }) async {
    var andriodIconSetting =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosIconSetting = const DarwinInitializationSettings();
    var iconSettings = InitializationSettings(
      android: andriodIconSetting,
      iOS: iosIconSetting,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      iconSettings,
      onDidReceiveNotificationResponse: (payload) {},
    );
  }

  Future<void> showNotification({required RemoteMessage message}) async {
    var channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      'high_importance_channel',
      importance: Importance.max,
    );
    var androidNotificationDetails = AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'your description',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      color: Colors.blue,
      playSound: true,
    );

    var darwinNotificationDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    var notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

  Future<String> getToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  refreshUserToken(String token) async {
    String user = Get.find<AuthController>().user!.uid;
    var userData = await db.usersCollection.doc(user).get();
    // var getPost = await db.postCollection.get();

    // if (getPost.docs.isNotEmpty) {
    //   getPost.docs.forEach((element) async {
    //     await FirebaseFirestore.instance
    //         .collection('posts')
    //         .doc(element.data()['uid'])
    //         .update({
    //       'token': token,
    //     });
    //   });
    // }
    if (userData['token'] == token) {
      print('token  $token');
      await db.usersCollection.doc(user).update({'token': token});
    } else {
      print('token refresh $token');
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      messaging.onTokenRefresh.listen((event) {
        token = event.toString();
      });
      await db.usersCollection.doc(user).update({'token': token});
    }
  }
}
