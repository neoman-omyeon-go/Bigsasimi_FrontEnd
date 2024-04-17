import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

//가로로 배치되어있는 성별, 나이, 키, 몸무게 위젯 부분
class UserInfoSection extends StatefulWidget {
  final String initialSex;
  final String initialAge;
  final String initialHeight;
  final String initialWeight;

  UserInfoSection({
    Key? key,
    required this.initialSex,
    required this.initialAge,
    required this.initialHeight,
    required this.initialWeight,
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
    sex = widget.initialSex;
    age = widget.initialAge;
    height = widget.initialHeight;
    weight = widget.initialWeight;
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
                    Text(sex, style: valueStyle),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _showPicker('age'),
                child: Column(
                  children: [
                    Text('Age', style: propertyStyle),
                    Text(age, style: valueStyle),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _showPicker('height'),
                child: Column(
                  children: [
                    Text('Height', style: propertyStyle),
                    Text(height, style: valueStyle),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _showPicker('weight'),
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
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 270,
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
        return List.generate(120, (index) => '${index + 100} cm');
      case 'weight':
        return List.generate(150, (index) => '${index + 30} kg');
      default:
        return [];
    }
  }
}
// 여기 까지 리팩토링 끝남


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

class EditableUserName extends StatefulWidget {
  final String initialName;

  const EditableUserName({Key? key, required this.initialName}) : super(key: key);

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
    _controller = TextEditingController(text: userName);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(userName, style: TextStyle(fontSize: 24)),  // userName 사용
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => showCustomDialog(context, "Username", _controller, () {
              setState(() {
                userName = _controller.text;  // 여기서 상태 업데이트
                Navigator.of(context).pop();
              });
            }),
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
          onPressed: onSave,
        ),
      ],
    ),
  );
}
