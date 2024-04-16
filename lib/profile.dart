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
            child: GestureDetector(
              onTap: _editProfilePicture,
              child: Icon(Icons.person, size: 80),
            ),
          ),
          SizedBox(height: 10),
          Center(child: Text('User Name', style: TextStyle(fontSize: 24))),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[
                UserInfoSection(
                  sex: 'Male',
                  age: '25',
                  height: '180cm',
                  weight: '75kg',
                  onEdit: () {
                    // UserInfoSection의 Edit 버튼을 클릭했을 때의 로직
                  },
                ),
                ProfileSectionButton(
                  title: 'Chronic Illnesses',
                  color: Colors.lightBlueAccent,
                  onTap: () {
                    // Chronic Illnesses 섹션의 Edit 버튼을 클릭했을 때의 로직
                  },
                ),
                ProfileSectionButton(
                  title: 'Allergies',
                  color: Colors.pinkAccent,
                  onTap: () {
                    // Allergies 섹션의 Edit 버튼을 클릭했을 때의 로직
                  },
                ),
                ProfileSectionButton(
                  title: 'Desired daily intake',
                  color: Colors.orangeAccent,
                  onTap: () {
                    // Desired daily intake 섹션의 Edit 버튼을 클릭했을 때의 로직
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _editProfilePicture() async {
    // image_picker 패키지를 사용하여 이미지를 선택하고 setState로 업데이트하는 로직을 추가
  }

  void _editSection(String title) {
    // 각 섹션의 정보를 입력할 수 있는 화면으로 이동하는 로직을 추가
  }
}

class EditableUserInfoRow extends StatefulWidget {
  final String title;
  final String value;

  const EditableUserInfoRow({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  _EditableUserInfoRowState createState() => _EditableUserInfoRowState();
}

class _EditableUserInfoRowState extends State<EditableUserInfoRow> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text(widget.title, style: TextStyle(fontSize: 18))),
        Expanded(
          child: TextFormField(
            controller: _controller,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
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
  final VoidCallback onTap;

  const ProfileSectionButton({
    Key? key,
    required this.title,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        title: Text(title, style: TextStyle(fontSize: 18)),
        trailing: Icon(Icons.edit),
        onTap: onTap,
      ),
    );
  }
}

class UserInfoSection extends StatelessWidget {
  final String sex;
  final String age;
  final String height;
  final String weight;
  final VoidCallback onEdit;

  const UserInfoSection({
    Key? key,
    required this.sex,
    required this.age,
    required this.height,
    required this.weight,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          UserInfoRow(title: 'Sex', value: sex),
          Divider(),
          UserInfoRow(title: 'Age', value: age),
          Divider(),
          UserInfoRow(title: 'Height', value: height),
          Divider(),
          UserInfoRow(title: 'Weight', value: weight),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: onEdit,
            ),
          ),
        ],
      ),
    );
  }
}