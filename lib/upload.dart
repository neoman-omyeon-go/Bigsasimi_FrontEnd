import 'package:capstone/intakenGraph.dart';
import 'package:capstone/localMapRestaurant.dart';
import 'package:capstone/todaysNews.dart';
import 'package:capstone/upload2.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'profile.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
//처음 화면 초기화시에, 로그인 성공~ 하면서 뜨게 해줄거임
//loginSuccessed();
class uploadScreen extends StatefulWidget {
  @override
  _uploadScreenState createState() => _uploadScreenState();
}

class _uploadScreenState extends State<uploadScreen> {
  int _selectedIndex = 2;  // Upload 페이지를 초기 선택된 탭으로 설정

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages = [
      TodaysNews(),
      LocalMapRestaurant(),
      UploadScreen(), // UploadScreen의 메인 컨텐츠
      IntakenGraph(),
      Profile(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Rendering Success');
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Graph',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _image;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 245, 235, 1.0),
      body: ListView( // 화면이 작을 경우 스크롤이 가능하도록 ListView를 사용합니다.
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: 20, right: 240),
              child: Text(
                'Record your diet.',
                style: TextStyle(
                  fontSize: 30, // 텍스트의 크기를 더 크게 변경합니다.
                  fontWeight: FontWeight.bold, // 글씨체를 굵게 합니다.
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Please take a photo of the foods Nutrition information',
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: _getImage, // 점선 테두리 상자를 탭하면 _getImage 함수를 호출합니다.
            child: DashedBorderBox(),
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 150.0, vertical: 10.0),
          child: TextButton(
            onPressed: () {
              // 'Click!' 버튼을 눌렀을 때 실행될 액션을 여기에 추가합니다.
            },
            child: Text('Send to server'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, // 텍스트 색상을 지정합니다.
              backgroundColor: Colors.black, // 배경 색상을 지정합니다.
            ),
          ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
              children: <Widget>[
                Icon(
                  Icons.report, // 느낌표 아이콘
                  color: Color.fromRGBO(237, 118, 81, 1.0),
                ),
                SizedBox(width: 10), // 아이콘과 텍스트 사이에 간격 추가
                Expanded( // 텍스트가 화면 너비를 벗어나지 않도록 Expanded 위젯을 사용합니다.
                  child: Text(
                    'If you want to search for a specific food, please press the button below.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0, right: 20.0), // 우측 하단으로 이동
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 200.0, // 버튼의 가로 크기
                height: 40.0,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // 그림자 색상
                      spreadRadius: 2, // 그림자 확산 정도
                      blurRadius: 5, // 그림자의 흐릿한 정도
                      offset: Offset(5, 5), // 그림자 위치 (가로, 세로)
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20.0), // 버튼의 둥근 모양
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // 'Click!' 버튼을 눌렀을 때 실행될 액션을 여기에 추가합니다.
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => upload2()),
                    );
                  },
                  child: Text('Click!'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // 버튼의 사각형 모양
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // 내부 여백
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromRGBO(237, 118, 81, 1.0),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DashedBorderBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(12),
        padding: EdgeInsets.all(6),
        dashPattern: [8, 4], // 점선의 패턴을 정의합니다. [선 길이, 공백 길이]
        strokeWidth: 2, // 선의 두께를 정의합니다.
        child: Container(
          color: Colors.white,
          width: 350, // 컨테이너의 너비
          height: 440, // 컨테이너의 높이
          alignment: Alignment.center,
          child: Icon(
            Icons.add,
            color: Colors.grey,
            size: 50,
          ),
        ),
      ),
    );
  }
}

