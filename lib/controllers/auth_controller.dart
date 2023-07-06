import 'package:firebase_auth/firebase_auth.dart';
 
import 'package:get/get.dart';

class AuthController extends GetxController
{
   final _auth=FirebaseAuth.instance;
   final Rx<User?> _firebaseUser=Rx<User?>(null);
    User? get user=>_firebaseUser.value;
  @override
  void onInit() {

    _firebaseUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }


}