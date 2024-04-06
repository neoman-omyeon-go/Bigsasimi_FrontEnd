import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'ProfileHome.dart';


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

  //처음 화면 초기화시에, 로그인 성공~ 하면서 뜨게 해줄거임
  @override
  void initState(){
    super.initState();
    loginSuccessed();
  }


  @override
  Widget build(BuildContext context) {
    // loginSuccessed();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
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
              color: Colors.blueGrey[100],
              child: Center(
                child: Text('Main Content'),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blueGrey,
        selectedItemColor: Colors.orangeAccent[200],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.today), label: 'Today\'s news',),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Restaurants nearby',),
          BottomNavigationBarItem(icon: Icon(Icons.upload), label: 'Upload',),
          BottomNavigationBarItem(icon: Icon(Icons.auto_graph), label: 'Today \'s intake information',),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile',),
        ],
        onTap: (index) {
          if(index == 4){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen())
            );
          }
        },
      ),
    );
  }
}

void loginSuccessed(){
  Fluttertoast.showToast(
      msg: "Login Successed~!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blueGrey,
      textColor: Colors.black,
      fontSize: 20.0
  );
}
