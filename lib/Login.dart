import 'package:capstone/Register.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'APIfile.dart';
import 'MainHome.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main(){
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.remove();
  runApp(MyLogin());
}

class MyLogin extends StatelessWidget {
  const MyLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Page',
      theme: ThemeData(primarySwatch: Colors.blue),
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

                      allApi().login(username, password);
                      //아래에 await delayed를 안주면, 로그인 정보를 불러오기까지 걸리는
                      //시간을 안줘버리게 되는거다.
                      // 즉, 저 딜레이가 있어야 token을 받아오고 저장하고, 확인하는 시간을
                      // 벌어주게 되는것이다.
                      checkIDandPassword();
                      await Future.delayed(Duration(seconds: 2));
                      Future<bool> checklogin = allApi().loginCheck();
                      bool realdata = await checklogin;
                      if(realdata){
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context)=> HomeScreen()),
                        );
                      }else{
                        //비밀번호가 틀렸을 때
                        requireLogin();
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
                loginSuccessed();
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

void checkIDandPassword(){
  Fluttertoast.showToast(
      msg: "Checking your ID or Password.....",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP_LEFT,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 20.0
  );
}

  void requireLogin(){
    Fluttertoast.showToast(
        msg: "Check your ID or Password And try Again",
        toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black45,
      textColor: Colors.white,
      fontSize: 20.0
    );
  }







