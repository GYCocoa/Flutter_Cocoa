import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../../provide/cart.dart';

class CartCount extends StatelessWidget {

  var item;
  CartCount(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      height: 30,
      margin: EdgeInsets.only(top: 5.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0,color: Colors.black12),
      ),
      child: Row(
        children: <Widget>[
          _reduceBtn(context),
          _countArea(),
          _addBtn(context),
        ],
      ),
    );
  }

  // 减号
  Widget _reduceBtn(context){
    return InkWell(
      onTap: (){
        Provide.value<CartProvide>(context).addOrReduceAction(item, 'reduce');
      },
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: item.count > 1 ? Colors.white : Colors.black12,
          border: Border(
            right: BorderSide(width: 1,color: Colors.black12),
          ),
        ),
        child: item.count > 1 ? Text('-') : Text(''),
      ),
    );
  }

  // 加号
  Widget _addBtn(context){
    return InkWell(
      onTap: (){
        Provide.value<CartProvide>(context).addOrReduceAction(item, 'add');
      },
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(width: 1,color: Colors.black12),
          ),
        ),
        child: Text('+'),
      ),
    );
  }

  // 中间数量显示区域
  Widget _countArea(){
    return Container(
      width: 50,
      height: 30,
      alignment: Alignment.center,
      color: Colors.white,
      child: Text('${item.count}',),
    );
  }

}