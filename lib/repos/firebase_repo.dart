import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:test/model/user_model.dart';

class FirebaseRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> uploadUsers() async {
    // Load JSON data from your assets
    final String response = await rootBundle.loadString('assets/result.json');
    final List<dynamic> data = json.decode(response);

    for (var userJson in data) {
      UserModel user = UserModel.fromJson(userJson);
      await _db.collection('users').add(user.toJson());
      print(user);
    }
  }

  Future<List<UserModel>> fetchUsers() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('users').get();
      List<UserModel> users = querySnapshot.docs.map((doc) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
      return users;
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }
}
