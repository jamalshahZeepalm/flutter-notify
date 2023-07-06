import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notifcationapp/binding/init_binding.dart';
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
  // Directory appDocDir = await getApplicationDocumentsDirectory();
  // String appDocPath = appDocDir.path;
  await Hive.initFlutter();
  await Hive.openBox('box');

  User? user = FirebaseAuth.instance.currentUser;
  runApp(MyApp(user: user));
}

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundMessaging(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print(message.notification!.title.toString());
}

class MyApp extends StatefulWidget {
  final User? user;

  const MyApp({super.key, this.user});

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
