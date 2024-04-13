import 'package:capstone/intakenGraph.dart';
import 'package:capstone/localMapRestaurant.dart';
import 'package:capstone/todaysNews.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'profile.dart';
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
      appBar: AppBar(
        title: Text('Young Yang Gang'),
        backgroundColor: Colors.blue,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
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

class UploadScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Center(child: Text("Upload Page Hello"));
  }
}

