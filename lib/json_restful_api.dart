import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prodemefa_app/data/json_user.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:prodemefa_app/locale/locales.dart';
import 'package:shared_preferences/shared_preferences.dart';

const EdgeInsets pad20 = const EdgeInsets.all(20.0);
const String spKey = 'myBool';
const String key = 'user_authenticationToken';
const String email = 'user_email';

class LoginWithRestfulApi extends StatefulWidget {




  @override
  _LoginWithRestfulApiState createState() => _LoginWithRestfulApiState();
}

class _LoginWithRestfulApiState extends State<LoginWithRestfulApi> {
  static var uri = "http://192.168.0.9:3000/api/v1";





  _save(JsonUser user) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'user_authenticationToken';
    final email = 'user_email';
    prefs.setString(key, user.authenticationToken);
    prefs.setString(email, user.email);

  }
  static BaseOptions options = BaseOptions(
      baseUrl: uri,
      responseType: ResponseType.plain,
      connectTimeout: 30000,
      receiveTimeout: 30000,
      validateStatus: (code) {
        if (code >= 200) {
          return true;
        }
      });
  static Dio dio = Dio(options);

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<dynamic> _loginUser(String email, String password) async {
    try {
      Options options = Options(
        contentType: ContentType.parse('application/json'),
      );

      Response response = await dio.post('/sessions/sign_in',
          data: {"email": email, "password": password}, options: options);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = json.decode(response.data);
        return responseJson;
      } else if (response.statusCode == 401) {
        setState(() => _isLoading = false);
        throw Exception("Incorrect Email/Password");
      } else
        setState(() => _isLoading = false);
        throw Exception('Authentication Error');
    } on DioError catch (exception) {
      if (exception == null ||
          exception.toString().contains('SocketException')) {
        setState(() => _isLoading = false);
        throw Exception("Network Error");
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        setState(() => _isLoading = false);
        throw Exception(
            "Could'nt connect, please ensure you have a stable network.");
      } else {
        return null;
      }
    }
  }
  SharedPreferences sharedPreferences;


  @override
  Widget build(BuildContext context) {

     {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text(AppLocalizations.of(context).title)),
        body: Center(
          child: _isLoading
              ? CircularProgressIndicator()
              : Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      hintText: 'Email', border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "Password",
                      border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                ),
              ),
              RaisedButton(
                child: Text('Read'),
                onPressed:  () async {
                  _read();
                },
              ),
              RaisedButton(
                child: Text("no ompa"),
                color: Colors.lightBlueAccent,
                onPressed: () async {
                  setState(() => _isLoading = true);
                  var res = await _loginUser(
                      _emailController.text, _passwordController.text);
                  setState(() => _isLoading = false);

                  JsonUser user = JsonUser.fromJson(res);
                  if (user != null) {

                    _save(user);
                    Navigator.of(context).pushReplacement(MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                          return new LoginScreen(
                            user: user,
                          );
                        }));
                  } else {
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text("Wrong email ")));
                  }
                },
              ),
            ],
          ),
        ),
      );
    }



  }


  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'user_authenticationToken';
    final email = 'user_email';

    Fluttertoast.showToast(
        msg:  prefs.get(email),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
    Fluttertoast.showToast(
        msg:  prefs.get(key),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}

class LoginScreen extends StatelessWidget {
  LoginScreen({@required this.user});

  final JsonUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Remove  Button"),leading: new Container(),
      ),
      body: Column(
          children: <Widget> [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                child: Text('Read'),
                onPressed:  () async {
                  _read();
                },
              ),
            ),

            user != null
                ? Text("Logged IN \n \n Email: ${user.email} ")
                : Text("Yore not Logged IN"),
          ]
      ),

    );
  }




  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'user_authenticationToken';
    final email = 'user_email';

    Fluttertoast.showToast(
        msg:  prefs.get(email),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
    Fluttertoast.showToast(
        msg:  prefs.get(key),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}