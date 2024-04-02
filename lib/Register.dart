import 'package:flutter/material.dart';

void main(){

}

class MySighUp extends StatelessWidget {
  const MySighUp({super.key});

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

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0.0,),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Register_origin.png"),
            fit: BoxFit.cover,
          )
        ),
        padding: EdgeInsets.all(16.0),
        child: SignUpForm(),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(width: 100, height: 100,),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),),
              ),
            ),
            SizedBox(width: 16.0, height: 50,),
            Expanded(
              child: TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),),
              ),
            ),
          ],
        ),
        SizedBox(height: 50.0,),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 50.0),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(),),
          obscureText: true,
        ),
        SizedBox(height: 50.0),
        ElevatedButton(
          onPressed: () {
            // Handle sign up logic here -> 입력받은 값들임
            String firstName = _firstNameController.text;
            String lastName = _lastNameController.text;
            String email = _emailController.text;
            String password = _passwordController.text;

            // You can perform validation or sign up operation here
            //이걸 print 해본거임
            print('First Name: $firstName');
            print('Last Name: $lastName');
            print('Email: $email');
            print('Password: $password');

            //여기서 이 값들을 바탕으로 로그인 정보를 만들어서 회원가입 시키면 됨
          },
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all<Size>(Size(200, 50)), // 버튼의 크기를 가로 200, 세로 50으로 변경
          ),
          child: Text('Sign Up'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
