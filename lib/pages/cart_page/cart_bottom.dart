import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/cart.dart';

class CartBottom extends StatelessWidget {
  const CartBottom({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      color: Colors.white,
      child: Provide<CartProvide>(
        builder: (context,child,childCategory){
          return Row(
              children: <Widget>[
              selectAllBtn(context),
              allPriceArea(context),
              goButton(context),
            ],
          );
        },
      ),
    );
  }

// 全选区域
  Widget selectAllBtn(context){
    bool isAllCheck = Provide.value<CartProvide>(context).isAllCheck;
    return Container(
      child: Row(
        children: <Widget>[
          Checkbox(
            value: isAllCheck,
            activeColor: Colors.pink,
            onChanged: (bool value){
              Provide.value<CartProvide>(context).changeAllCheckBtnState(value);
            },
          ),
          Text('全选'),

        ],
      ),
    );
  }

  // 价格区域
  Widget allPriceArea(context){
    double allPrice = Provide.value<CartProvide>(context).allPrice;

    return Container(
      padding: EdgeInsets.only(left: 20),
      width: ScreenUtil().setWidth(450),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  '合计：',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(36),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                width: ScreenUtil().setWidth(210),
                child: Text(
                  '￥${allPrice}',
                  style:TextStyle(
                    fontSize:ScreenUtil().setSp(36),
                    color:Colors.red,
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: ScreenUtil().setWidth(450),
            alignment: Alignment.centerLeft,
            child: Text(
              '满10元免配送费,预购免配送费',
              style:TextStyle(
                color:Colors.black38,
                fontSize: ScreenUtil().setSp(22),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 结算
  Widget goButton(context){
    int allGoodsCount = Provide.value<CartProvide>(context).allGoodsCount;
    return Container(
      width: ScreenUtil().setWidth(160),
      padding: EdgeInsets.only(left: 10),
      child: InkWell(
        onTap: (){

        },
        child: Container(
          padding: EdgeInsets.all(10.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(3.0),
          ),
          child: Text(
            '结算(${allGoodsCount})',
            style:TextStyle(
              color:Colors.white
            ),
          ),
        ),
      ),
    );
  }
}