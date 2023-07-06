// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notifcationapp/Repository/auth_repo.dart';
import 'package:flutter_notifcationapp/model/user_model.dart';
import 'package:flutter_notifcationapp/views/user_dashbaord.dart';
import 'package:hive/hive.dart';

import '../admin_dashboard.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  String selectedValue = 'Select UserType';
  AuthRepo authRepo = AuthRepo();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            DropdownButton<String>(
              value: selectedValue,
              items: <String>['Select UserType', 'User', 'Admin']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue = newValue!;
                });
                print(selectedValue);
              },
            ),
            ElevatedButton(
              onPressed: () {
                UserModel userModel = UserModel(
                    uid: '',
                    name: _nameController.text.trim(),
                    email: _emailController.text.trim(),
                    userType: selectedValue,
                    token: '');
                authRepo.signUp(
                    userModel: userModel,
                    password: _passwordController.text.trim());
              },
              child: const Text('Signup'),
            ),
          ],
        ),
      ),
    );
  }
}
