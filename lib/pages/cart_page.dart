import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.shopping_cart)),
              Tab(icon: Icon(Icons.credit_card)),
              Tab(icon: Icon(Icons.receipt))
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _cartTab(),
            _cardsTab(),
            _ordersTab()
          ],
        ),
      ),
    );

  }
  Widget _cartTab() {
    return Text('cart');
  }

  Widget _cardsTab() {
    return Text('cards');
  }

  Widget _ordersTab() {
    return Text('orders');
  }

}
