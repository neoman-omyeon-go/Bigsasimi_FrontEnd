import 'package:capstone/tab_item.dart';
import 'package:flutter/material.dart';
import 'navbarItems.dart';
import 'tab_item.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({required this.currentTab, required this.onSelectTab});
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.blueGrey,

      items: [
        _buildItem(TabItem.todaysNews),
        _buildItem(TabItem.localMapRestaurant),
        _buildItem(TabItem.upload),
        _buildItem(TabItem.intakenGraph),
        _buildItem(TabItem.profile),
      ],

      onTap: (index) => onSelectTab(
        TabItem.values[index],
      ),
      currentIndex: currentTab.index,
      selectedItemColor: Colors.orangeAccent[200]
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    return navbarItems[tabIdx[tabItem]!];
  }
}