import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'profile_userinfo.dart';

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
          onTap: _editProfilePicture,
          child: CircleAvatar(
            radius: 80, // 원하는 크기로 설정하세요.
            backgroundColor: Colors.grey[200], // 아바타 배경색 지정
            child: _image != null
                ? ClipOval(child: Image.file(_image!, fit: BoxFit.cover, width: 160, height: 160)) // 이미지가 있는 경우
                : Icon(Icons.person, size: 80), // 이미지가 없는 경우 아이콘 표시
          ),
        ),
          SizedBox(height: 10),
          EditableUserName(initialName: 'User Name'), // 초기 사용자 이름 설정
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[
                UserInfoSection(
                  initialSex: 'Male',
                  initialAge: '25',
                  initialHeight: '180cm',
                  initialWeight: '75kg',
                ),
                ProfileSectionButton(
                  title: 'Chronic Illnesses',
                  color: Colors.lightBlueAccent,
                  // onTap: () {
                  //   // Chronic Illnesses 섹션의 Edit 버튼을 클릭했을 때의 로직
                  // },
                ),
                ProfileSectionButton(
                  title: 'Allergies',
                  color: Colors.pinkAccent,
                  // onTap: () {
                  //   // Allergies 섹션의 Edit 버튼을 클릭했을 때의 로직
                  // },
                ),
                ProfileSectionButton(
                  title: 'Desired daily intake',
                  color: Colors.orangeAccent,
                  // onTap: () {
                  //   // Desired daily intake 섹션의 Edit 버튼을 클릭했을 때의 로직
                  // },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //프로필 사진 업로드
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
}






