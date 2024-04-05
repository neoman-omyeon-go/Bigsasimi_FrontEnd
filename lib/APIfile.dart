import 'dart:js_interop';
import 'dart:math';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'dart:convert';
import 'package:capstone/Register.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class allApi{
  static final storage = FlutterSecureStorage();

  //Login API Request
  void login(String username, String password) async {
    var url = 'http://127.0.0.1:8080/api/login/';

    // 요청할 데이터를 Map으로 구성합니다.
    var data = {
      'username': username,
      'password': password,
    };

    try {
      var dio = Dio();
      Response response = await dio.post(url, data: data, options: Options(headers: {'Content-Type': 'application/json; charset=UTF-8',},),);

      if (response.statusCode == 200) {
        // 성공적으로 요청이 완료된 경우

        print("Login successfully!");

        Map<String, dynamic> responseMap = response.data;
        var accessToken = responseMap["access"];
        var refreshToken = responseMap["refresh"];

        await storage.write(key: 'accessToken', value: accessToken);
        await storage.write(key: 'refeshToken', value: refreshToken);
        print("Access: ${accessToken}");
        print("Refress: ${refreshToken}");


      } else {
        // 요청이 실패한 경우
        print("Failed to login. Error: ${response.statusCode}");
        print("Response body: ${response.data}");
      }
    } catch (error) {
      // 예외 처리
      print("Error occurred: $error");
    }
  }

  Future<bool> loginCheck() async{
    bool check = false;
    String? value = await storage.read(key: 'accessToken');
    if(value != null){
      check = true;
    }

    return check;
  }






//SignUp API Request
  void signUp(String username, String password, String email) async {
    var url = 'http://127.0.0.1:8000/api/signup/';

    // 요청할 데이터를 Map으로 구성합니다.
    var data = {
      'username': username,
      'password': password,
      'email': email,
    };

    try {
      var dio = Dio();
      Response response = await dio.post(url, data: data, options: Options(headers: {'Content-Type': 'application/json; charset=UTF-8',},),);

      if (response.statusCode == 200) {
        // 성공적으로 요청이 완료된 경우
        print("Signed up successfully!");
        print("${response.data}");
      } else {
        // 요청이 실패한 경우
        print("Failed to sign up. Error: ${response.statusCode}");
        print("Response body: ${response.data}");
      }
    } catch (error) {
      // 예외 처리
      print("Error occurred: $error");
    }
  }
}


