import 'package:flutter/material.dart';
import '../model/category.dart';

// 监测变化
class ChildCategory with ChangeNotifier{

  List<BxMallSubDto> childCategoryList = [];
  int childIndex = 0; // 子类高亮索引
  String categoryId = '4'; // 大类ID 默认4
  String subId = ''; // 小类id
  int page = 1; // 列表页数
  String noMoreText = ''; // 显示没有数据的文字

  // 大类切换逻辑
  getChildCategory(List<BxMallSubDto> list,String id){

    childIndex = 0;
    categoryId = id;
    page = 1;
    noMoreText = '';

    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = '';
    all.mallCategoryId = '';
    all.comments = 'null';
    all.mallSubName = '全部';
    childCategoryList = [];
    childCategoryList.add(all);
    childCategoryList.addAll(list);
    // 通知变化
    notifyListeners();

  }

    // 改变子类索引
  changeChildIndex(index,String id){
    childIndex = index;
    subId = id;
    page = 1;
    noMoreText = '';

    // 通知变化
    notifyListeners();
  }

  // 增加page的方法
  addPage(){
    page++;
  }

  changeNoMore(String text){
    noMoreText = text;
    notifyListeners();
  }

}