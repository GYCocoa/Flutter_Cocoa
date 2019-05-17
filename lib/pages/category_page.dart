import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../model/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/child_category.dart';
import '../model/categoryGoodsList.dart';
import '../provide/category_goods_list.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../routers/application.dart';

class CategoryPage extends StatefulWidget{

  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>{

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('商品分类'),
        elevation: 0,
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            LeftCategoryNav(),
            Column(
              children: <Widget>[
                RightCategoryNav(),
                CategoryGoodsList(),

              ],
            )
          ],
        ),
      ),
    );
  }
}


// 左侧导航
class LeftCategoryNav extends StatefulWidget{

  LeftCategoryNav({Key key}) : super (key:key);
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav>{

  List list = [];
  var indexList = 0;

  @override
  void initState() {
    super.initState();

    _getCategory();
    _getGoodsList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      margin: EdgeInsets.only(top: 1),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 1,color: Colors.black12),
        ),
      ),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context,index){
            return _leftInkWell(index);
          },
      ),
    );
  }

  Widget _leftInkWell(int index){

    bool isClick = false;
    isClick = index == indexList ? true : false;
    return Center(
      child: InkWell(
        onTap: (){
          setState(() {
            indexList = index;
          });
          var childList = list[index].bxMallSubDto;
          var categoryId = list[index].mallCategoryId;
          Provide.value<ChildCategory>(context).getChildCategory(childList,categoryId);
          _getGoodsList(categoryId: categoryId);
        },
        child: Container(
          height: ScreenUtil().setHeight(100),
          width: ScreenUtil().setWidth(180),
          padding: EdgeInsets.only(left: 10,top: 17.5),
          decoration: BoxDecoration(
            color: isClick ? Colors.pink : Colors.white,
            border: Border(
              bottom: BorderSide(width: 1,color: Colors.black12)
            )
          ),
          child: Text(list[index].mallCategoryName,style: TextStyle(fontSize: ScreenUtil().setSp(30),color: isClick ? Colors.white : Colors.black),),
        ),
      ),
    );
  }

  void _getCategory() async {
    await request('getCategory').then((val){
      var data = json.decode(val.toString());
//      print('getCategory${data}');
      CategoryModel category = CategoryModel.fromJson(data);
        setState(() {
          list = category.data;
          if(list.length > 0) {
            var childList = list[0].bxMallSubDto;
            var categoryId = list[0].mallCategoryId;
            Provide.value<ChildCategory>(context).getChildCategory(childList,categoryId);
          }
        });
    });
  }

  // 可选 categoryId
  void _getGoodsList({String categoryId}) async {
    var data = {
      'categoryId' : categoryId==null ? '4' : categoryId,
      'categorySubId' : '',
      'pageId' : 1
    };

    await request('getMallGoods',formData: data).then((val){
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      Provide.value<CategoryGoodsListProvide>(context).getGoodsList(goodsList.data);
    });
  }
}

// 右侧导航
class RightCategoryNav extends StatefulWidget{

  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav>{

  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>(
      builder:(context,child,childCategory){
        return Container(
          height: ScreenUtil().setHeight(80),
          width: ScreenUtil().setWidth(570),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(width: 1,color: Colors.black12),
            ),
          ),
          child: ListView.builder(
            itemBuilder:(context,index){
              return _rightInkWell(index,childCategory.childCategoryList[index]);
            },
            itemCount: childCategory.childCategoryList.length,
            scrollDirection: Axis.horizontal,
          ),
        );
      },
    );
  }

  Widget _rightInkWell(int index,BxMallSubDto item){

    bool isClick = index == Provide.value<ChildCategory>(context).childIndex ? true : false;

    return InkWell(
      onTap: (){
        // 修改所点击的颜色
        Provide.value<ChildCategory>(context).changeChildIndex(index,item.mallSubId);
        _getGoodsList(item.mallSubId);
        print(item);
        print(item.mallSubId);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 13, 10, 13),
        child: Text(
          item.mallSubName,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(28),
            color: isClick ? Colors.pink : Colors.black,
          ),
        ),
      ),
    );
  }

  // 必选categoryId
  void _getGoodsList(String categorySubId) async {
    var data = {
      'categoryId' : Provide.value<ChildCategory>(context).categoryId,
      'categorySubId' : categorySubId,
      'pageId' : 1
    };

    await request('getMallGoods',formData: data).then((val){
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      goodsList.data = goodsList.data != null ? goodsList.data : [];
      Provide.value<CategoryGoodsListProvide>(context).getGoodsList(goodsList.data);
    });
  }

}

// 商品列表 可以上拉加载
class CategoryGoodsList extends StatefulWidget{

  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList>{

  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();

  var scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Provide<CategoryGoodsListProvide>(
        builder: (context,child,data){

          try{
            if(Provide.value<ChildCategory>(context).page == 1){
              // 列表位置放到最上边
              scrollController.jumpTo(0.0);
            }
          }catch(e){
            print('第一次进入页面:${e}');
          }

          if(data.goodsList.length == 0){
            return Container(
              height: ScreenUtil().setHeight(600),
              child: Center(
                child: Text('暂无数据'),
              ),
            );
          }
          return Expanded(
              child: Container(
                width: ScreenUtil().setWidth(570),
                child:EasyRefresh(
                  refreshFooter: ClassicsFooter(
                    key: _footerKey,
                    bgColor: Colors.white,
                    textColor: Colors.pink,
                    moreInfoColor: Colors.pink,
                    showMore: true,
                    noMoreText: Provide.value<ChildCategory>(context).noMoreText,
                    moreInfo: '加载中...',
                    loadReadyText: '上拉加载...',
                  ),
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: data.goodsList.length,
                      itemBuilder: (context,index){
                        return _listItemWidget(data.goodsList,index);
                      },
                    ),
                  loadMore: () async{
                    print('上拉加载更多......');
                    _getMoreList();
                  },
                ),
              ),
          );
        }
    );
  }

  // 必选categoryId
  void _getMoreList() {
    Provide.value<ChildCategory>(context).addPage();
    var data = {
      'categoryId' : Provide.value<ChildCategory>(context).categoryId,
      'categorySubId' : Provide.value<ChildCategory>(context).subId,
      'pageId' : Provide.value<ChildCategory>(context).page
    };
    print(data);

    request('getMallGoods',formData: data).then((val){
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      if(goodsList.data == null){
        Provide.value<ChildCategory>(context).changeNoMore('没有更多了');
      }else{
        Provide.value<CategoryGoodsListProvide>(context).getMoreList(goodsList.data);
      }
    });
  }

  Widget _goodsImage(List newList,index){

    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(newList[index].image),
    );
  }

  Widget _goodsName(List newList,index){
    return Container(
      padding: EdgeInsets.all(5),
      width: ScreenUtil().setWidth(370),
      child: Text(
        newList[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }

  Widget _goodsPrice(List newList,index){
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: ScreenUtil().setWidth(370),
      child: Row(
        children: <Widget>[
          Text(
            '价格${newList[index].presentPrice}',
            style: TextStyle(color: Colors.pink,fontSize: ScreenUtil().setSp(30)),
          ),
          Text(
            '￥${newList[index].oriPrice}',
            style: TextStyle(color: Colors.black26,fontSize: ScreenUtil().setSp(30),decoration: TextDecoration.lineThrough),
          ),
        ],
      )
    );
  }

  Widget _listItemWidget(List newList,index){

    return InkWell(
      onTap: (){
        // print('newList = ${newList}');
        var  model = new CategoryListData();
        model = newList[index];
        Application.router.navigateTo(context, "/detail?id=${model.goodsId}");
      },
      child: Container(
        padding: EdgeInsets.only(top: 5,bottom: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1,color: Colors.black12),
          ),
        ),
        child: Row(
          children: <Widget>[
            _goodsImage(newList,index),
            Column(
              children: <Widget>[
                _goodsName(newList,index),
                _goodsPrice(newList,index),
              ],
            ),
          ],
        ),
      ),
    );
  }

}











