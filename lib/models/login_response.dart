// To parse this JSON data, do
//
// final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';
import 'package:chat_app_test/models/user_model.dart';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  bool? ok;
  User? user;
  String? token;

  LoginResponse({this.ok, this.user, this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        ok: json["ok"],
        user: User.fromJson(json["user"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "user": user!.toJson(),
        "token": token,
      };
}
