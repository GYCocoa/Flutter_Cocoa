import 'package:flutter/material.dart';

// 监测变化
class Counter with ChangeNotifier{

  int value = 0;

  increment(){
    value ++;
    // 通知变化
    notifyListeners();
  }
}