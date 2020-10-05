import 'dart:convert';
import 'package:flutter_ecommerce/models/app_state.dart';
import 'package:flutter_ecommerce/models/user.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

ThunkAction<AppState> getUserAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  final String storedUser = prefs.getString('user');
  final user = storedUser != null ? User.fromJson(json.decode(storedUser)) : null;
  store.dispatch(GetUserAction(user));
};

class GetUserAction{
  final User _user;
  GetUserAction(this._user);
  User get user => this._user;
}

ThunkAction<AppState> getProductAction = (Store<AppState> store) async {
  http.Response response = await http.get('http://10.0.0.5:1337/products');
  final List<dynamic> responseData = json.decode(response.body);
  store.dispatch(GetProductsAction(responseData));
};

ThunkAction<AppState> logoutUserAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('user');
  User user;
  store.dispatch(LogoutUserAction(user));
};


class GetProductsAction{
  final List<dynamic> _products;
  List<dynamic> get products => this._products;
  GetProductsAction(this._products);
}

class LogoutUserAction{
  final User _user;
  LogoutUserAction(this._user);
  User get user => this._user;
}