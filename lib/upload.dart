import 'package:capstone/BottomNavigation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'profile.dart';
import 'tab_item.dart';
import 'tabnavigator.dart';

//처음 화면 초기화시에, 로그인 성공~ 하면서 뜨게 해줄거임
//loginSuccessed();
class uploadScreen extends StatefulWidget {
  @override
  State<uploadScreen> createState() => _uploadScreenState();
}

class _uploadScreenState extends State<uploadScreen> {
  @override
  var _currentTab = TabItem.upload;

  final _navigatorKeys = {
    TabItem.todaysNews: GlobalKey<NavigatorState>(),
    TabItem.localMapRestaurant: GlobalKey<NavigatorState>(),
    TabItem.upload: GlobalKey<NavigatorState>(),
    TabItem.intakenGraph: GlobalKey<NavigatorState>(),
    TabItem.profile: GlobalKey<NavigatorState>(),
  };

  void _selectTab(TabItem tabItem){
    if(tabItem == _currentTab){
      _navigatorKeys[tabItem]!.currentState?.popUntil((route) => route.isFirst);
    }else{
      setState(() => _currentTab = tabItem);
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
        !await _navigatorKeys[_currentTab]!.currentState!.maybePop();

        if (isFirstRouteInCurrentTab) {
          // 메인 화면이 아닌 경우
          if (_currentTab != TabItem.upload) {
            // 메인 화면으로 이동
            _selectTab(TabItem.upload);
            // 앱 종료 방지
            return false;
          }
        }

        /// 네비게이션 바의 첫번째 스크린인 경우, 앱 종료
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            _buildOffstageNavigator(TabItem.todaysNews),
            _buildOffstageNavigator(TabItem.localMapRestaurant),
            _buildOffstageNavigator(TabItem.upload),
            _buildOffstageNavigator(TabItem.intakenGraph),
            _buildOffstageNavigator(TabItem.profile),
          ],
        ),
        bottomNavigationBar: BottomNavigation(
          currentTab: _currentTab,
          onSelectTab: _selectTab,
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    /// (offstage == false) -> 트리에서 완전히 제거된다.
    return Offstage(
        offstage: _currentTab != tabItem,
        child: TabNavigator(
          navigatorKey: _navigatorKeys[tabItem],
          tabItem: tabItem,
        ));
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
