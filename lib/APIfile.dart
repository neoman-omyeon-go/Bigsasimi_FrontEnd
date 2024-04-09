import 'dart:io';
import 'dart:js';
import 'dart:js_interop';
import 'dart:math';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'dart:convert';
import 'package:capstone/Register.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class allApi{
  static final storage = FlutterSecureStorage();

  //Login API Request
  Future<bool> login(String username, String password) async {
    var url = 'http://127.0.0.1:8080/api/login/';
    var checkdata;

    // 요청할 데이터를 Map으로 구성합니다.
    var data = {
      'username': username,
      'password': password,
    };

    // var dio = Dio();
    // Response response = await dio.post(url, data: data, options: Options(headers: {'Content-Type': 'application/json; charset=UTF-8',},),);

    try {
      var dio = Dio();
      Response response = await dio.post(url, data: data, options: Options(headers: {'Content-Type': 'application/json; charset=UTF-8',},),);
      if (response.statusCode == 200 || response.statusCode == 400) {
        // 성공적으로 요청이 완료된 경우
        print("Login successfully!");

        Map<String, dynamic> responseMap = response.data;
        var accessToken = responseMap["data"]["access"];
        var refreshToken = responseMap["data"]["refresh"];
        var error = responseMap["error"];

        print("Access: ${accessToken}");
        print("Refress: ${refreshToken}");
        print("Error value in Status 200 : ${error}");

        await storage.write(key: 'accessToken', value: accessToken);
        await storage.write(key: 'refeshToken', value: refreshToken);
        await storage.write(key: 'error', value: error);

        checkdata = loginCheck();
      }
    } catch (error) {
      // 예외 처리
      print("Error occurred: $error");
      storage.write(key: 'error', value: "error");
      checkdata = false;
    }
    return checkdata;
  }

  Future<bool> loginCheck() async{
    bool check = false;
    String? value = await storage.read(key: 'error');
    print("Login check error:${value}");
    if(value == null){
      check = true;
      print(check);
    }
    print(check);
    return check;
  }


//SignUp API Request
  Future<bool> signUp(String username, String password, String email) async {
    var url = 'http://127.0.0.1:8000/api/signup/';
    var registerCheckvalue;
    // 요청할 데이터를 Map으로 구성합니다.
    var data = {
      'username': username,
      'password': password,
      'email': email,
    };

    try {
      var dio = Dio();
      final response = await dio.post(url, data: data, options: Options(headers: {'Content-Type': 'application/json; charset=UTF-8',},),);

      if (response.statusCode == 200) {
        // 성공적으로 요청이 완료된 경우
        print("Signed up successfully!");
        print("${response.data}");
        print("statusCode: ${response.statusCode}");
        await storage.write(key: 'msg', value: null);

        registerCheckvalue = registerCheck();
      }
    } catch (error) {
      // 예외 처리
      // 어짜피 200을 제외한 모든 Status Code는 catch에서 잡힌다니까
      // 그럼 여기서 토스트 메세지를 띄워주면 되겠네 ㅇㅇ 아이디가 중복된다. 라고
      print("Error occurred: $error");
      await storage.write(key: 'msg', value: "Duplicated");
      registerCheckvalue = false;
    }
    return registerCheckvalue;
  }

  //storage는 AllApi의 클래스에 전역 공간에 선언된 FlutterSecureStorage 임.
  // 그래서 storage를 사용할거면, class 안에다가 함수를 맹글어야 함.
  Future<bool> registerCheck() async{
    bool check = false;
    String? value = await storage.read(key: 'msg');
    print("Register check error:${value}");

    if(value == null){
        check = true;
        print(check);
    }
    print(check);

    return check;
  }
}











