import 'package:capstone/APIfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
import 'APIfile.dart';


//가로로 배치되어있는 성별, 나이, 키, 몸무게 위젯 부분
class UserInfo {
  late String userName;
  late String sex;
  late String age;
  late String height;
  late String weight;

  UserInfo({
    required this.userName,
    required this.sex,
    required this.age,
    required this.height,
    required this.weight,
  });
}

class UserInfoSection extends StatefulWidget {
  final UserInfo userInfo;
  final Function(UserInfo) onUpdateUserInfo; // 새로운 콜백 함수 추가

  const UserInfoSection({
    Key? key,
    required this.userInfo,
    required this.onUpdateUserInfo, // 변경된 콜백 함수
  }) : super(key: key);

  @override
  _UserInfoSectionState createState() => _UserInfoSectionState();
}

class _UserInfoSectionState extends State<UserInfoSection> {
  late UserInfo userInfo;

  @override
  void initState() {
    super.initState();
    userInfo = widget.userInfo;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle propertyStyle = TextStyle(fontSize: 16, color: Colors.grey);
    TextStyle valueStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: () => _showPicker('sex'),
                child: Column(
                  children: [
                    Text('Sex', style: propertyStyle),
                    Text(userInfo.sex, style: valueStyle),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _showPicker('age'),
                child: Column(
                  children: [
                    Text('Age', style: propertyStyle),
                    Text(userInfo.age, style: valueStyle),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _showPicker('height'),
                child: Column(
                  children: [
                    Text('Height', style: propertyStyle),
                    Text('${userInfo.height} cm', style: valueStyle),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _showPicker('weight'),
                child: Column(
                  children: [
                    Text('Weight', style: propertyStyle),
                    Text('${userInfo.weight} kg', style: valueStyle),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPicker(String fieldType) {
    final List<String> items = _getPickerItems(fieldType);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoButton(
                    child: Text('Select'),
                    onPressed: () {
                      widget.onUpdateUserInfo(userInfo); // 수정된 정보를 전달
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 270,
              child: CupertinoPicker(
                itemExtent: 28.0,
                onSelectedItemChanged: (int index) {
                  setState(() {
                    switch (fieldType) {
                      case 'sex':
                        userInfo.sex = items[index];
                        break;
                      case 'age':
                        userInfo.age = items[index];
                        break;
                      case 'height':
                        userInfo.height = items[index];
                        break;
                      case 'weight':
                        userInfo.weight = items[index];
                        break;
                    }
                  });
                },
                children: items.map((String value) {
                  return Center(child: Text(value));
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  List<String> _getPickerItems(String fieldType) {
    switch (fieldType) {
      case 'sex':
        return ['Male', 'Female', 'Other'];
      case 'age':
        return List.generate(110, (index) => '${index + 1}');
      case 'height':
        return List.generate(120, (index) => '${index + 100}');
      case 'weight':
        return List.generate(150, (index) => '${index + 30}');
      default:
        return [];
    }
  }
}
// 여기 까지 리팩토링 끝남


class EditableUserName extends StatefulWidget {
  final UserInfo userInfo; // 현재 사용자 정보
  final String initialName;
  final Function(UserInfo) onUpdateUserInfo; // 사용자 정보 업데이트 콜백 함수

  const EditableUserName({
    Key? key,
    required this.userInfo,
    required this.initialName,
    required this.onUpdateUserInfo
  }) : super(key: key);

  @override
  _EditableUserNameState createState() => _EditableUserNameState();
}

class _EditableUserNameState extends State<EditableUserName> {
  late TextEditingController _controller;
  late String userName;  // 상태 변수로 userName 추가

  @override
  void initState() {
    super.initState();
    userName = widget.initialName;  // 초기 값 설정
    // userName = userinfo2;  // 초기 값 설정
    _controller = TextEditingController(text: userName);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_controller.text, style: TextStyle(fontSize: 24)),  // userName 사용
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _controller.text = userName;  // 현재 userName을 TextField에 설정
              showCustomDialog(context, "Username", _controller, () {
                setState(() {
                  userName = _controller.text;  // TextField에서 변경된 userName을 상태에 반영
                  // 사용자 정보 업데이트
                  UserInfo updatedUserInfo = UserInfo(
                    userName: userName,
                    sex: widget.userInfo.sex,
                    age: widget.userInfo.age,
                    height: widget.userInfo.height,
                    weight: widget.userInfo.weight,
                  );
                  // 변경 사항을 상위 위젯에 알림
                  widget.onUpdateUserInfo(updatedUserInfo);
                });
              });
            },
            tooltip: 'Edit Username',
          ),
        ],
      ),
    );
  }

}



// 만성 질환, 알레르기, 일일 섭취량 관련 선택 버튼
class ProfileSectionButton extends StatelessWidget {
  final String title;
  final Color color;

  ProfileSectionButton({
    Key? key,
    required this.title,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _textEditingController = TextEditingController();
    return Card(
      color: color,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
        title: Text(title, style: TextStyle(fontSize: 18)),
        trailing: Icon(Icons.edit),
        onTap: () => showCustomDialog(context, title, _textEditingController, () {
          // 저장 로직 구현
          Navigator.of(context).pop();
        }),
      ),
    );
  }
}


// 다이얼로그를 쓰기위한 공용 함수처리
void showCustomDialog(BuildContext context, String title, TextEditingController controller, VoidCallback onSave) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Edit $title'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(
          hintText: "Enter your $title",
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('Save'),
          onPressed: () {
            print(controller.text);
            allApi().updateToserver2(controller.text);  // API로 데이터 전송
            onSave();  // 콜백 함수 호출
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}




