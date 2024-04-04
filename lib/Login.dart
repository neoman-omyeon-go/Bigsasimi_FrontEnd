import 'package:capstone/Register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'APIfile.dart';

import 'MainHome.dart';

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

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

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
                  onPressed: () {
                    String username = _usernameController.text;
                    String password = _passwordController.text;
                    login(username, password);
                    // Navigator.push(context,
                    //   MaterialPageRoute(builder: (context)=> HomeScreen()),
                    // );
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


//   void Login(String username, String password) async {
//     var url = Uri.parse('http://127.0.0.1:8080/api/login/');
//
//     // 요청할 데이터를 Map으로 구성합니다.
//     var data = {
//       'username': username,
//       'password': password,
//     };
//     print(data);
//     // JSON 형식으로 변환합니다.
//     var jsonData = jsonEncode(data);
//
//     print("try operating");
//     try {
//       var response = await http.post(url, headers: {'Content-Type': 'application/json; charset=UTF-8',}, body: jsonData,);
//       // var response = await http.get(url,);
//       if (response.statusCode == 200) {
//         // 성공적으로 요청이 완료된 경우
//         print("Login successfully!");
//         print("${response.body}");
//       } else {
//         // 요청이 실패한 경우
//         print("Failed to sign up. Error: ${response.statusCode}");
//         print("Response body: ${response.body}");
//       }
//     } catch (error) {
//       // 예외 처리
//       print("Error occurred: $error");
//     }
//   }
// }