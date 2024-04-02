import 'package:flutter/material.dart';

import 'ProfileHome.dart';

void main() {

}

class MainHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isDrawerOpen = false;
  bool _isListVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            setState(() {
              _isDrawerOpen = !_isDrawerOpen;
            });
          },
        ),
      ),
      body: Row(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: _isDrawerOpen ? 200.0 : 0.0,
            child: Drawer(
              child: ListView(
                children: [
                  ListTile(
                    title: Text('Item 1'),
                  ),
                  ListTile(
                    title: Text('Item 2'),
                  ),
                  ListTile(
                    title: Text('Item 3'),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _isListVisible = !_isListVisible;
              });
            },
            child: AnimatedOpacity(
              opacity: _isListVisible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Center(
                child: Text('Main Content'),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: '오늘의 정보',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: '주변 식당',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '프로필',
          ),
        ],
        onTap: (index) {
          if(index == 2){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen())
            );
          }
        },
      ),
    );
  }
}
