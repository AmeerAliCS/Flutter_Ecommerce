import 'package:meta/meta.dart';

@immutable
class AppState{
  final dynamic user;
  final List<dynamic> products;
  final List<dynamic> cartProducts;

  AppState({@required this.user, @required this.products, @required this.cartProducts});

  factory AppState.initial(){
    return AppState(
      user: null,
      products: [],
      cartProducts: []
    );
  }

}