import 'package:flutter/material.dart';
import 'package:capstone/todaysNews.dart';
import 'package:capstone/tab_item.dart';
import 'package:capstone/localMapRestaurant.dart';
import 'package:capstone/upload.dart';
import 'package:capstone/profile.dart';
import 'package:capstone/intakenGraph.dart';


enum TabItem { todaysNews, localMapRestaurant, upload, intakenGraph, profile }

const Map<TabItem, int> tabIdx = {
  TabItem.todaysNews: 0,
  TabItem.localMapRestaurant: 1,
  TabItem.upload: 2,
  TabItem.intakenGraph: 3,
  TabItem.profile: 4,
};

Map<TabItem, Widget> tabScreen = {
  TabItem.todaysNews: todaysNewsScreen(),
  TabItem.localMapRestaurant: localMapRestaurantScreen(),
  TabItem.upload: uploadScreen(),
  TabItem.intakenGraph: intakenGraphScreen(),
  TabItem.profile: profileScreen(),
};