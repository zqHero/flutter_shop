import 'package:flutter/material.dart';

//内容  通知类  更新状态   切换 底部   导航栏
class CurrentIndexProvide with ChangeNotifier {
  int currentIndex = 0;

  changeIndex(int newIndex) {
    currentIndex = newIndex;
    notifyListeners();
  }
}
