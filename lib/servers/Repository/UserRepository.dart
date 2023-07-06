import 'dart:convert';

import 'package:dio/dio.dart';

import '../../helpers/constans.dart';

class UserRepository {
  final Dio _dio = Dio();
  final String getUserUrl = "users";
  String? error;

  Future<List<User>?> getUserList() async {
    try {
      final response = await _dio.get(ApiLink.apiAddres + "users");
      final List userlist = response.data;
      return userlist.map((e) => User.fromJson(e)).toList();
    } catch (e) {
      return null;
    }
  }

  Future<bool> changePasswordUser(User user) async {
    try {
      final json =  user.toPutJson();
      final response =
          await _dio.put(ApiLink.apiAddres + "Users/"+user.idUser.toString(), data:user.toPutJson());
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204  ) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> createUser(User user) async {
    try {
      final response =
          await _dio.post(ApiLink.apiAddres + "Users", data: user.toJson());
      print(response);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}

class User {
  final int idUser;
  final String nameUser;
  final String secondNameUser;
  final String emailUser;
  late String passwordUser;
  final String phoneNumberUser;
  final String? adressUser;
  late String? profileImageUser;

  User(
      {required this.idUser,
      required this.nameUser,
      required this.secondNameUser,
      required this.emailUser,
      required this.passwordUser,
      required this.phoneNumberUser,
      required this.adressUser,
      required this.profileImageUser});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idUser: json['idUser'],
      nameUser: json['nameUser'],
      secondNameUser: json['secondNameUser'],
      emailUser: json['emailUser'],
      passwordUser: json['passwordUser'],
      phoneNumberUser: json['phoneNumberUser'],
      adressUser: json['addressUser'],
      profileImageUser: json['profileImageUser'],
    );
  }
  Map<String, dynamic> toPutJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idUser'] = this.idUser;
    data['nameUser'] = this.nameUser;
    data['secondNameUser'] = this.secondNameUser;
    data['emailUser'] = this.emailUser;
    data['passwordUser'] = this.passwordUser;
    data['phoneNumberUser'] = this.phoneNumberUser;
    data['addressUser'] = this.adressUser;
    data['profileImageUser'] = this.profileImageUser;
    return data;
  }
   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nameUser'] = this.nameUser;
    data['secondNameUser'] = this.secondNameUser;
    data['emailUser'] = this.emailUser;
    data['passwordUser'] = this.passwordUser;
    data['phoneNumberUser'] = this.phoneNumberUser;
    data['addressUser'] = this.adressUser;
    data['profileImageUser'] = this.profileImageUser;
    return data;
  }
}
