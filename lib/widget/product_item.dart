import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/pages/product_detail_page.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ProductItem extends StatelessWidget {

  final dynamic item;
  ProductItem({this.item});


  @override
  Widget build(BuildContext context) {
    final String pictureUrl = 'http://10.0.0.5:1337${item['picture'][0]['url']}';

    return InkWell(
       onTap: (){
         Navigator.of(context).push(MaterialPageRoute(builder: (context){
           return ProductDetailPage(item: item);
         }));
       },
       child: GridTile(
        footer: GridTileBar(
          backgroundColor: Color(0xBB000000),
          title: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(item['name'], style: TextStyle(fontSize: 20)),
          ),
          subtitle: Text('\$${item['price']}', style: TextStyle(fontSize: 16)),
          trailing: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (_, state){
              return state.user != null ? IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.white,),
                onPressed: (){
                  print('Shopping');
                },
              ) : Text('');
            },
          ),
        ),
        child: Hero(
            tag: item,
            child: Image.network(pictureUrl, fit: BoxFit.cover,)
        ),
      ),
    );
  }
}
