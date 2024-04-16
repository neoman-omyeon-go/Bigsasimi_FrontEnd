import 'package:flutter/material.dart';

// Profile 페이지가 별도의 화면으로서 다른 페이지에서 네비게이션으로 이동할 때
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(height: 30),
          CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 80),
          ),
          SizedBox(height: 10),
          Center(child: Text('User Name', style: TextStyle(fontSize: 24))),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const <Widget>[
                    Expanded(
                      child: UserInfoRow(title: 'Sex', value: 'Male'),
                    ),
                    Expanded(
                      child: UserInfoRow(title: 'Age', value: '25'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const <Widget>[
                    Expanded(
                      child: UserInfoRow(title: 'Height', value: '180cm'),
                    ),
                    Expanded(
                      child: UserInfoRow(title: 'Weight', value: '75kg'),
                    ),
                  ],
                ),
                ProfileSectionButton(title: 'Chronic Illnesses', color: Colors.lightBlueAccent),
                ProfileSectionButton(title: 'Allergies', color: Colors.pinkAccent),
                ProfileSectionButton(title: 'Desired daily intake', color: Colors.orangeAccent),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserInfoRow extends StatelessWidget {
  final String title;
  final String value;

  const UserInfoRow({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: 16, color: Colors.grey)),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class ProfileSectionButton extends StatelessWidget {
  final String title;
  final Color color;

  const ProfileSectionButton({Key? key, required this.title, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
        title: Text(title, style: TextStyle(fontSize: 18)),
        onTap: () {
          // 해당 섹션 클릭시 동작 추가
        },
      ),
    );
  }
}