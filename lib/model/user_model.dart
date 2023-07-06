import 'dart:convert';

class UserModel {
  String uid;
  String name;
  String email;
  String userType;
  String token;
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.userType,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'uid': uid});
    result.addAll({'name': name});
    result.addAll({'email': email});
    result.addAll({'userType': userType});
    result.addAll({'token': token});
  
    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      userType: map['userType'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
