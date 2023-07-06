// ignore_for_file: use_build_context_synchronously, invalid_return_type_for_catch_error

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notifcationapp/Repository/auth_repo.dart';
import 'package:flutter_notifcationapp/Repository/post_repo.dart';
import 'package:flutter_notifcationapp/controllers/notifications_controller.dart';
import 'package:flutter_notifcationapp/controllers/post_controller.dart';
import 'package:flutter_notifcationapp/controllers/user_controller.dart';

import 'package:get/get.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  AuthRepo authRepo = AuthRepo();

  UserController userController = Get.find<UserController>();
  PostController pc = Get.put(PostController());
  PostRepo postRepo = PostRepo();
  NotificationController nfc = Get.find<NotificationController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Row(
              children: [
                const Text('Admin DashBoard'),
                const SizedBox(
                  width: 10,
                ),
                Text(userController.user!.name)
              ],
            )),
        actions: [
          IconButton(
              onPressed: () async {
                await authRepo.signOut();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Obx(() {
        return pc.adminPostList!.isEmpty
            ? const Center(
                child: Text('No Data Found'),
              )
            : ListView.builder(
                itemCount: pc.adminPostList!.length,
                itemBuilder: (context, index) {
                  var myData = pc.adminPostList![index];
                  // if (kDebugMode) {
                  //   print(snapshot.data!.docs[index]['title'].toString());
                  // }
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            myData.title.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            myData.description.toString(),
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              const SizedBox(
                                width: 40,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  postRepo.statusChangePost(
                                      myData: myData, status: 'active');

                                  nfc.pushNotificationsSpecificDevice(
                                    body: myData.description,
                                    title: 'post approve',
                                    token: myData.token,
                                  );
                                  
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
      }),
    );
  }
}
