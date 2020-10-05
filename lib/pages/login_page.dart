import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String  _email, _password;
  bool _isSubmitting, _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Flutter E-Commerce'),
        centerTitle: true,
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _showTitle(),
                    _showEmailInput(),
                    _showPasswordInput(),
                    _showFormActions()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _showTitle(){
    return Text('Login', style: Theme.of(context).textTheme.headline1);
  }
  Widget _showEmailInput(){
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: TextFormField(
        onSaved: (val) => _email = val,
        validator: (val) => !val.contains('@') ? 'Invalid Email' : null,
        decoration: InputDecoration(
          hintText: 'Enter a valid email',
          labelText: 'Email',
          border: OutlineInputBorder(),
          icon: Icon(Icons.mail),
        ),
      ),
    );

  }
  Widget _showPasswordInput(){
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: TextFormField(
        obscureText: _obscureText,
        onSaved: (val) => _password = val,
        validator: (val) => val.length < 6 ? 'Password too short' : null,
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            onTap: (){
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          ),
          hintText: 'Enter password, min length 6',
          labelText: 'Password',
          border: OutlineInputBorder(),
          icon: Icon(Icons.lock),
        ),
      ),
    );
  }
  Widget _showFormActions(){
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          _isSubmitting == true ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
          ) : RaisedButton(
            child: Text('Submit', style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.black)),
            elevation: 0.8,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))
            ),
            color: Theme.of(context).accentColor,
            onPressed: _submit,
          ),

          FlatButton(
            child: Text('New user? register'),
            onPressed: () => Navigator.pushReplacementNamed(context, '/register'),
          )
        ],
      ),
    );
  }

  void _submit(){
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
      _loginUser();
    }
  }

  void _loginUser() async {
    setState(() {
      _isSubmitting = true;
    });
    http.Response response = await http.post('http://10.0.0.5:1337/auth/local',
        body: {
          'identifier' : _email,
          'password' : _password
        }
    );
    final responseData = json.decode(response.body);
    if(response.statusCode == 200){
      setState(() {
        _isSubmitting = false;
      });
      _storeUserData(responseData);
      _showSuccessSnack();
      _redirectUser();
      print(responseData);
    }
    else{
      setState(() {
        _isSubmitting = false;
      });
      // final String errorMsg = 'Error !';
      final errorMsg = responseData['message'];
      _showErrorSnack(errorMsg.toString());
      print(responseData['message']);
    }

  }

  void _showSuccessSnack(){
    final snackbar = SnackBar(
      content: Text(
        'successfully login!', style: TextStyle(color: Colors.green),
      ),
      backgroundColor: Colors.black54,
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
    _formKey.currentState.reset();
  }

  void _showErrorSnack(String errorMsg) {
    final snackbar =
    SnackBar(content: Text(errorMsg, style: TextStyle(color: Colors.red)),
      backgroundColor: Colors.black54,
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
    // throw Exception('Error registering: $errorMsg');
  }

  void _redirectUser() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  void _storeUserData(responseData) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String , dynamic> user = responseData['user'];
    user.putIfAbsent('jwt', () => responseData['jwt']);
    prefs.setString('user', json.encode(user));
  }

}
