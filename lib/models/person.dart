import 'dart:convert';

import 'package:quantum_assignment/services/connection_service.dart';
import 'package:quantum_assignment/services/firebase_database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Person {
  String uid;
  String name;
  String email;
  String phoneNo;

  Person(
      {required this.uid,
      required this.name,
      required this.email,
      required this.phoneNo});

  factory Person.fromJson(Map<String, dynamic> json) => Person(
      uid: json['uid'] ?? "",
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      phoneNo: json['phoneNo'] ?? "");

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "email": email,
        "phoneNo": phoneNo,
      };

  Future<void> updatePerson() async {
    await FirebaseDatabaseService().set("Users/$uid", toJson());
  }

  static Future<Person?> fromUid(String uid) async {
    if(await ConnectionService().isConnectedToInternet()){
      final json = await FirebaseDatabaseService().get("Users/$uid");
      if(json == null){
        return null;
      }
      return Person.fromJson(json);
    }
    return await loadFromLocal(uid);

  }

  saveToLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(uid, jsonEncode(toJson()));
  }

  static Future<Person?> loadFromLocal(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final cacheData = prefs.getString(uid);
    if(cacheData == null){
      return null;
    }
    return Person.fromJson(await jsonDecode(cacheData));
  }
}
