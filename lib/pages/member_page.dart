import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class MemberPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('会员中心'),
      ),
      body: ListView(
        children: <Widget>[
          _topHeader(),
          _orderTitle(),
          _orderType(),
          _actionList(),

        ],
      ),
    );
  }

  Widget _topHeader(){
    String headerUrl = 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558072413483&di=f89ee5971f0919f38ef98cca31a3d81a&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fblog%2F201410%2F31%2F20141031051941_QRMMZ.jpeg';
    return Container(
      width: ScreenUtil().setWidth(750),
      padding: EdgeInsets.all(20),
      color: Colors.pinkAccent,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 15.0),
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(75),
                image: DecorationImage(
                  image: NetworkImage(headerUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              'Kevin.Zhang',
              style:TextStyle(
                fontSize: ScreenUtil().setSp(36),
                color:Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 我的订单
  Widget _orderTitle(){
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1.0,color: Colors.black12),
        ),
      ),
      child: ListTile(
        leading: Icon(Icons.list),
        title: Text('我的订单'),
        trailing:Icon(Icons.keyboard_arrow_right),
      ),
    );
  }

  Widget _orderType(){
    return Container(
      margin: EdgeInsets.only(top: 5),
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(150),
      padding: EdgeInsets.only(top:20),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.no_sim,
                  size: 30,
                  ),
                  Text('待付款'),
              ],
            ),
          ),

          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.query_builder,
                  size: 30,
                  ),
                  Text('待发货'),
              ],
            ),
          ),

          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.directions_car,
                  size: 30,
                  ),
                  Text('待收货'),
              ],
            ),
          ),

          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.content_paste,
                  size: 30,
                  ),
                  Text('待评价'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 通用ListTitle
  Widget _myListTitle(title,icon){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.black12,
          ),
        ),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Icon(Icons.keyboard_arrow_right),
      ),
    );
  }

  Widget _actionList(){
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: <Widget>[
          _myListTitle('领取优惠券', Icons.crop_square),
          _myListTitle('已领取优惠券', Icons.crop_portrait),
          _myListTitle('地址管理', Icons.markunread),
          _myListTitle('客服电话', Icons.phone_forwarded),
          _myListTitle('关于我们', Icons.memory),

        ],
      ),
    );
  }

}