import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// Profile 페이지가 별도의 화면으로서 다른 페이지에서 네비게이션으로 이동할 때
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _image; // 사용자가 선택한 이미지 파일을 저장

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(height: 30),
          GestureDetector(
            // onTap: _editProfilePicture,
            // child: CircleAvatar(
            //   radius: 50,
            //   backgroundImage: _image != null ? FileImage(_image!) : null,
            //   child: _image == null ? Icon(Icons.person, size: 80) : null,
            // ),
            onTap: _editProfilePicture,
            child: _image != null ? Image.file(_image!) : Icon(Icons.person, size: 80),
          ),
          SizedBox(height: 10),
          EditableUserName(initialName: 'User Name'), // 초기 사용자 이름 설정
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
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print("Selected image path: ${image.path}");  // 경로 출력
      setState(() {
        _image = File(image.path);
      });
    } else {
      print("No image selected");
    }
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
        contentPadding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
        title: Text(title, style: TextStyle(fontSize: 18)),
        trailing: Icon(Icons.edit),
        onTap: onTap,
      ),
    );
  }
}

class UserInfoRow extends StatelessWidget {
  final String sex;
  final String age;
  final String height;
  final String weight;
  final VoidCallback onSexTap;
  final VoidCallback onAgeTap;
  final VoidCallback onHeightTap;
  final VoidCallback onWeightTap;

  UserInfoRow({
    Key? key,
    required this.sex,
    required this.age,
    required this.height,
    required this.weight,
    required this.onSexTap,
    required this.onAgeTap,
    required this.onHeightTap,
    required this.onWeightTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle propertyStyle = TextStyle(fontSize: 16, color: Colors.grey);
    TextStyle valueStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: onSexTap,
                child: Column(
                  children: [
                    Text('Sex', style: propertyStyle),
                    Text(sex, style: valueStyle),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onAgeTap,
                child: Column(
                  children: [
                    Text('Age', style: propertyStyle),
                    Text(age, style: valueStyle),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onHeightTap,
                child: Column(
                  children: [
                    Text('Height', style: propertyStyle),
                    Text(height, style: valueStyle),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onWeightTap,
                child: Column(
                  children: [
                    Text('Weight', style: propertyStyle),
                    Text(weight, style: valueStyle),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class UserInfoSection extends StatefulWidget {
  final String sex;
  final String age;
  final String height;
  final String weight;

  UserInfoSection({
    Key? key,
    required this.sex,
    required this.age,
    required this.height,
    required this.weight,
  }) : super(key: key);

  @override
  _UserInfoSectionState createState() => _UserInfoSectionState();
}

class _UserInfoSectionState extends State<UserInfoSection> {
  late String sex;
  late String age;
  late String height;
  late String weight;

  @override
  void initState() {
    super.initState();
    sex = widget.sex;
    age = widget.age;
    height = widget.height;
    weight = widget.weight;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: UserInfoRow(
        sex: sex,
        age: age,
        height: height,
        weight: weight,
        onSexTap: () => _showPicker('sex'),
        onAgeTap: () => _showPicker('age'),
        onHeightTap: () => _showPicker('height'),
        onWeightTap: () => _showPicker('weight'),
      ),
    );
  }

  void _showPicker(String fieldType) {
    final List<String> items = _getPickerItems(fieldType);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: 500,
          height: 350, // 피커 뷰의 세로 길이를 200px로 설정
          child: CupertinoPicker(
            itemExtent: 28.0,
            onSelectedItemChanged: (int index) {
              setState(() {
                switch (fieldType) {
                  case 'sex':
                    sex = items[index];
                    break;
                  case 'age':
                    age = items[index];
                    break;
                  case 'height':
                    height = items[index];
                    break;
                  case 'weight':
                    weight = items[index];
                    break;
                }
              });
            },
            children: items.map((String value) {
              return Center(child: Text(value));
            }).toList(),
          ),
        );
      },
    );
  }


  List<String> _getPickerItems(String fieldType) {
    switch (fieldType) {
      case 'sex':
        return ['Male', 'Female', 'Other', 'Nothing'];
      case 'age':
        return List.generate(130, (index) => '${index + 1}');
      case 'height':
        return List.generate(251, (index) => '${index} cm');
      case 'weight':
        return List.generate(250, (index) => '${index + 1} kg');
      default:
        return [];
    }
  }
}

class EditableUserName extends StatefulWidget {
  final String initialName;

  const EditableUserName({Key? key, required this.initialName}) : super(key: key);

  @override
  _EditableUserNameState createState() => _EditableUserNameState();
}

class _EditableUserNameState extends State<EditableUserName> {
  late TextEditingController _controller;
  late String userName;

  @override
  void initState() {
    super.initState();
    userName = widget.initialName;
    _controller = TextEditingController(text: userName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _editName() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Username'),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(hintText: "Enter new username"),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Change'),
            onPressed: () {
              setState(() {
                userName = _controller.text;
                Navigator.of(context).pop();
                //userName을 API를 통해서 서버로 보내야 함.
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min, // Row의 크기를 내용물에 맞춤
        mainAxisAlignment: MainAxisAlignment.center, // 요소들을 Row의 중앙에 배치
        children: [
          Text(
            userName,
            style: TextStyle(fontSize: 24),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editName,
            tooltip: 'Edit Username',
          ),
        ],
      ),
    );
  }
}





