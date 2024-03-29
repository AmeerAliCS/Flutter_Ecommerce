import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/pages/products_page.dart';

class ProductDetailPage extends StatelessWidget {

  final item;
  ProductDetailPage({this.item});

  @override
  Widget build(BuildContext context) {
    final String pictureUrl = 'http://10.0.0.5:1337${item['picture'][0]['url']}';
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: Text(item['name']),
        centerTitle: true,
      ),
      body: Container(
        decoration: gradientBackground,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Hero(
                 tag: item,
                 child: Image.network(pictureUrl, width: orientation == Orientation.portrait ? 600 : 250,
                    height: orientation == Orientation.portrait ? 400 : 200,),
              ),
            ),

            Text(item['name'], style: Theme.of(context).textTheme.bodyText1,),
            Text('\$${item['price']}', style: Theme.of(context).textTheme.bodyText1,),
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 32.0, right: 32.0, bottom: 32.0),
                  child: Text(item['description']),
                ),
              ),
            )

          ],
        ),
    ),
    );
  }
}
