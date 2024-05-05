import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'profile_userinfo.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _image;
  List<String> selectedChronicIllnesses = [];
  List<String> selectedAllergies = [];

  List<String> chronicIllnesses = [
    '운동 부족',
    '비만',
    '고혈압',
    '성인병',
    '당뇨병',
    '고지혈증',
  ];

  List<String> allergies = [
    '알류',
    '우유',
    '메밀',
    '땅콩',
    '대두',
    '밀',
    '잣',
    '호두',
    '게',
    '새우',
    '오징어',
    '고등어',
    '조개류',
    '복숭아',
    '토마토',
    '아황산류 와인',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(height: 30),
          GestureDetector(
            onTap: _editProfilePicture,
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.grey[600],
              child: _image != null
                  ? ClipOval(
                child: Image.file(
                  _image!,
                  fit: BoxFit.cover,
                  width: 160,
                  height: 160,
                ),
              )
                  : Icon(
                Icons.person,
                size: 100,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 10),
          EditableUserName(initialName: 'User Name'),
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
                SizedBox(height: 20),
                ProfileSectionButton(
                  title: 'Chronic Illnesses',
                  color: Colors.lightBlue.shade100,
                  onTap: () {
                    _showChronicIllnessesDialog();
                  },
                  selectedItems: selectedChronicIllnesses,
                ),
                SizedBox(height: 20),
                ProfileSectionButton(
                  title: 'Allergies',
                  color: Colors.pink.shade100,
                  onTap: () {
                    _showAllergiesDialog();
                  },
                  selectedItems: selectedAllergies,
                ),
                SizedBox(height: 20),
                ProfileSectionButton(
                  title: 'Desired daily intake',
                  color: Colors.orange.shade100,
                  onTap: () {
                    // Desired daily intake 섹션의 Edit 버튼을 클릭했을 때의 로직
                  },
                  selectedItems: [], // Desired daily intake 섹션은 선택된 항목이 없으므로 빈 리스트 전달
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
    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print("Selected image path: ${image.path}");
      setState(() {
        _image = File(image.path);
      });
    } else {
      print("No image selected");
    }
  }

  void _showChronicIllnessesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chronic Illnesses'),
          content: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (BuildContext context, setState) {
                return ListBody(
                  children: chronicIllnesses
                      .map(
                        (illness) => CheckboxListTile(
                      title: Text(illness),
                      value: selectedChronicIllnesses.contains(illness),
                      onChanged: (value) {
                        setState(() {
                          if (value!) {
                            if (!selectedChronicIllnesses.contains(illness)) {
                              selectedChronicIllnesses.add(illness);
                            }
                          } else {
                            selectedChronicIllnesses.remove(illness);
                          }
                        });
                      },
                    ),
                  )
                      .toList(),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {}); // 변경사항을 반영하기 위해 setState 호출
              },
            ),
          ],
        );
      },
    );
  }

  void _showAllergiesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Allergies'),
          content: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (BuildContext context, setState) {
                return ListBody(
                  children: allergies
                      .map(
                        (allergy) => CheckboxListTile(
                      title: Text(allergy),
                      value: selectedAllergies.contains(allergy),
                      onChanged: (value) {
                        setState(() {
                          if (value!) {
                            if (!selectedAllergies.contains(allergy)) {
                              selectedAllergies.add(allergy);
                            }
                          } else {
                            selectedAllergies.remove(allergy);
                          }
                        });
                      },
                    ),
                  )
                      .toList(),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {}); // 변경사항을 반영하기 위해 setState 호출
              },
            ),
          ],
        );
      },
    );
  }



}

class ProfileSectionButton extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;
  final List<String> selectedItems;

  const ProfileSectionButton({
    required this.title,
    required this.color,
    required this.onTap,
    required this.selectedItems,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: selectedItems
                      .map(
                        (item) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Chip(
                        label: Text(
                          item,
                          style: TextStyle(fontSize: 14),
                        ),
                        backgroundColor: Colors.grey[300],
                        labelPadding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                      ),
                    ),
                  )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

