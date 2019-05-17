import 'package:flutter/material.dart';
import '../model/categoryGoodsList.dart';

// 监测变化
class CategoryGoodsListProvide with ChangeNotifier{

  List<CategoryListData> goodsList = [];

  // 点击大类时更换商品列表
  getGoodsList(List<CategoryListData> list){
    goodsList = list;

    // 通知变化
    notifyListeners();
  }

  // 点击大类时更换商品列表
  getMoreList(List<CategoryListData> list){
    goodsList.addAll(list);

    // 通知变化
    notifyListeners();
  }
}