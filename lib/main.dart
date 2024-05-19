import 'dart:developer';

import 'package:capstone/Register.dart';
import 'package:capstone/profile_userinfoWidget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'APIfile.dart';
import 'upload.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

void main() async{
  await _initializeNaverMap();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.remove();
  runApp(MyLogin());
}

Future<void> _initializeNaverMap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
      clientId: 'klci72ut3v',
      onAuthFailed: (e) => log("********* 네이버맵 인증오류 : $e *********"));
}


class MyLogin extends StatelessWidget {
  const MyLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Page',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Pretendard'),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key:key);

  @override
  State<LoginPage> createState() => _LoginPageState();
 }

 class _LoginPageState extends State<LoginPage>{
  @override
    var _usernameController = TextEditingController();
    var _passwordController = TextEditingController();

    @override
    Widget build(BuildContext context){
      return Scaffold(
        // appBar: AppBar(title: Text('Login Page'),),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Login_origin.png"), // 배경 이미지 경로 설정
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'PassWord',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true, // 패스워드 입력 필드
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          // "Forgot Password?" 텍스트를 클릭할 때 수행될 동작
                          // 아이디, 비밀번호 찾기 페이지로 이동

                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async{
                      String username = _usernameController.text;
                      String password = _passwordController.text;

                      Future<bool> checklogin = allApi().login(username, password);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Checking your ID And Password.....'),
                            duration: const Duration(milliseconds: 700),
                          )
                      );
                      bool realdata = await checklogin;
                      //아래에 await delayed를 안주면, 로그인 정보를 불러오기까지 걸리는
                      //시간을 안줘버리게 되는거다.
                      // 즉, 저 딜레이가 있어야 token을 받아오고 저장하고, 확인하는 시간을
                      // 벌어주게 되는것이다.
                      await Future.delayed(Duration(seconds: 1));
                      // Future<bool> checklogin = allApi().loginCheck();
                      allApi().getUserState();
                      // allApi().getUserProfile();
                      if (!mounted) return;  // 여기서 위젯이 아직 존재하는지 확인
                      if(realdata){
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Login Successed~!'),
                              duration: const Duration(milliseconds: 900),
                            )
                        );
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => uploadScreen()),
                              (Route<dynamic> route) => false,
                        );
                      }else{
                        //비밀번호가 틀렸을 때
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Check your ID or Password And try Again'),
                              duration: const Duration(milliseconds: 900),
                            )
                        );
                      }

                      // 로그인 버튼 눌렀을 때 실행될 동작
                    },
                    child: Text('Log in'),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: TextStyle(color: Colors.blue),
            ),
            TextButton(
              onPressed: () {
                // "Sign up" 텍스트를 클릭할 때 수행될 동작
                // 회원가입 페이지로 이동
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text(
                'Sign up',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      );
    }

  }








