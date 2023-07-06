import 'dart:convert';

class PostModel {
  String id;
  String title;
  String description;
  String status;
  String uid;
  String token;
  PostModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.uid,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'description': description});
    result.addAll({'status': status});
    result.addAll({'uid': uid});
    result.addAll({'token': token});
  
    return result;
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      status: map['status'] ?? '',
      uid: map['uid'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) => PostModel.fromMap(json.decode(source));
}
