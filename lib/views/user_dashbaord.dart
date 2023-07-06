// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_notifcationapp/Repository/auth_repo.dart';
import 'package:flutter_notifcationapp/Repository/post_repo.dart';
import 'package:flutter_notifcationapp/Services/database_helper.dart';
import 'package:flutter_notifcationapp/controllers/post_controller.dart';
import 'package:flutter_notifcationapp/controllers/user_controller.dart';
import 'package:flutter_notifcationapp/create_post.dart';
import 'package:get/get.dart';

import '../controllers/notifications_controller.dart';

class Post {
  final String title;
  final String description;

  Post({required this.title, required this.description});
}

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final List<Post> _posts = [
    Post(title: 'Post 1', description: 'Description for post 1'),
    Post(title: 'Post 2', description: 'Description for post 2'),
    Post(title: 'Post 3', description: 'Description for post 3'),
  ];

  AuthRepo authRepo = AuthRepo();
  DatabaseService databaseService = DatabaseService();
  PostRepo postRepo = PostRepo();

  NotificationController nfc = Get.find<NotificationController>();
  UserController userController = Get.find<UserController>();
  PostController pc = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Row(
              children: [
                const Text('User DashBoard'),
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
      // body: StreamBuilder<QuerySnapshot>(
      //   stream: FirebaseFirestore.instance
      //       .collection('posts')
      //       .where('status', isEqualTo: 'active')
      //       .snapshots(),
      //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //     if (snapshot.hasData) {
      //       return ;
      //     }
      //     return const Center(
      //       child: CircularProgressIndicator(),
      //     );
      //   },
      // ),
      body: Obx(() {
        return   pc.userPostList!.isEmpty
                ? const Center(
                    child: Text('No Data Found'),
                  )
                : ListView.builder(
                    itemCount: pc.userPostList!.length,
                    itemBuilder: (context, index) {
                      var myData = pc.userPostList![index];
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
                                    onPressed: ()async {
                                      await postRepo.statusChangePost(
                                          myData: myData, status: 'pending');
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

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String token = nfc.token!;
          log(token + "token is here");
          Get.to(() => CreatePostScreen(token: token));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // refreshUserToken(String token) async {
  //   String user = FirebaseAuth.instance.currentUser!.uid;
  //   log("user id $user");
  //   var dataget =
  //       await FirebaseFirestore.instance.collection('users').doc(user).get();
  //   var getPost = await FirebaseFirestore.instance.collection('posts').get();

  //   if (getPost.docs.isNotEmpty) {
  //     getPost.docs.forEach((element) async {
  //       await FirebaseFirestore.instance
  //           .collection('posts')
  //           .doc(element.data()['uid'])
  //           .update({
  //         'token': token,
  //       });
  //     });
  //   }
  //   log('${dataget['token']}  token');
  //   if (dataget['token'] == token) {
  //     print('token  $token');
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user)
  //         .update({'token': token});
  //   } else {
  //     print('token refresh $token');
  //     FirebaseMessaging messaging = FirebaseMessaging.instance;
  //     messaging.onTokenRefresh.listen((event) {
  //       token = event.toString();
  //     });
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user)
  //         .update({'token': token});
  //   }
  // }
}
