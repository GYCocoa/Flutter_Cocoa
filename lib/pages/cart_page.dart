import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/cart.dart';
import '../pages/cart_page/cart_item.dart';
import '../pages/cart_page/cart_bottom.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
      ),
      body: FutureBuilder(
        future: _getCartInfo(context),
        builder: (context,snapShot){
          if(snapShot.hasData){
            List cartList = Provide.value<CartProvide>(context).cartList;

            return Stack(
              children: <Widget>[
                Provide<CartProvide>(
                  builder: (context,child,childCategory){
                    cartList = Provide.value<CartProvide>(context).cartList;
                    return ListView.builder(
                              itemCount: cartList.length,
                              itemBuilder: (context,index){
                              return CartItem(cartList[index]);
                        },
                      );
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: CartBottom(),
                ),
              ],
            );

          }else{
            return Text('正在加载');
          }
        },
      ),
    );
  }

  Future<String> _getCartInfo(BuildContext context) async {
    await Provide.value<CartProvide>(context).getCartInfo();
    return 'end';
  }
}
