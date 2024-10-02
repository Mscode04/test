import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'package:flutter/material.dart';
import 'package:test/model/user_model.dart';
import 'package:test/repos/firebase_repo.dart';

class UserController extends ChangeNotifier {
  List<UserModel> users = [];

  bool isLoading = false;
  List<UserModel> allUsers = [];

  Future<void> fetchUsers() async {
    isLoading = true;
    notifyListeners();

    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      users = await FirebaseRepo().fetchUsers();
      allUsers = List.from(users);
    } else {
      final String response = await rootBundle.loadString('assets/result.json');
      final List<dynamic> data = json.decode(response);
      users = data.map((json) => UserModel.fromJson(json)).toList();
      allUsers = List.from(users);
    }

    isLoading = false;
    notifyListeners();
  }

   searchUser(String searchText) {
    if (searchText.isEmpty) {
      users = List.from(allUsers);
    } else {
      users = allUsers.where((user) {
        final fullName = '${user.firstName} ${user.lastName}'.toLowerCase();
        return fullName.contains(searchText.toLowerCase());
     
      }).toList();
    }
    notifyListeners();
  }
}
