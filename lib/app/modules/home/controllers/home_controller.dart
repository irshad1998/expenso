import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class HomeController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController primaryTabController;

  var selectedIndex = 0.obs;

  selectIndex(int index) => selectedIndex.value = index;

  var showFab = true.obs;
  final primaryTabList = <String>['Income', 'Expense', 'Transfers'];

  final navIcoData = <IconData>[
    CupertinoIcons.home,
    CupertinoIcons.person,
    CupertinoIcons.home,
    CupertinoIcons.person,
    CupertinoIcons.arrow_left_right_square
  ];

  @override
  void onInit() {
    super.onInit();
    primaryTabController = TabController(length: primaryTabList.length, vsync: this);
  }
}
