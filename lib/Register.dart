import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'APIfile.dart';

class MySignUp extends StatelessWidget {
  const MySignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Up Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/SignUpFinall.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(15.0),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView( // Scroll 가능하도록 설정
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // SizedBox(
                  //   height: 100,
                  // ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 50.0),
                  ElevatedButton(
                    onPressed: () async {
                      // Handle sign up logic here -> 입력받은 값들임
                      String username = _usernameController.text;
                      String password = _passwordController.text;
                      String email = _emailController.text;

                      // Register API CALL
                      Future<bool> checkRegister = allApi().signUp(username, password, email);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Checking your ID is duplicating.....'),
                          duration: const Duration(milliseconds: 700),
                        ),
                      );
                      await Future.delayed(Duration(seconds: 2));
                      bool realdata = await checkRegister;
                      if (realdata) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Sign Up Successed!'),
                            duration: const Duration(milliseconds: 700),
                          ),
                        );
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Your Id is duplicated. Enter another ID'),
                            duration: const Duration(milliseconds: 700),
                          ),
                        );
                      }

                      await Future.delayed(Duration(seconds: 1));
                      // You can perform validation or sign up operation here
                      print('UserName: $username');
                      print('Password: $password');
                      print('Email: $email');
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(
                        Size(200, 50), // 버튼의 크기를 가로 200, 세로 50으로 변경
                      ),
                    ),
                    child: Text('Sign Up'),
                  ),
                ],
              ),
            ),
          ),

        ),
      ),
    );
  }
}
