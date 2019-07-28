import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/json_user.dart';
import 'json_restful_api.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:prodemefa_app/locale/locales.dart';
void main() => runApp(MyApp());


class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  createState() => new MyAppState();
}

const EdgeInsets pad20 = const EdgeInsets.all(20.0);
const String spKey = 'myBool';
const String key = 'user_authenticationToken';
const String email = 'user_email';
JsonUser currentUser;
//prefs.setString(key, user.authenticationToken);
//prefs.setString(email, user.email);
class MyAppState extends State<MyApp> {
  SharedPreferences sharedPreferences;

  bool _testValue;
  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      var authenticationToken = sharedPreferences.get(key);
      var emailload  = sharedPreferences.get(email);
      print(emailload);
      print(authenticationToken);
      currentUser = JsonUser(email: emailload , authenticationToken: authenticationToken);
      // will be null if never previously saved
      if (authenticationToken  == null) {
        _testValue = false;
      }else {_testValue = true;}
      setState(() {});
    });

  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ""),
        Locale('es', ''),
      ],
      onGenerateTitle: (BuildContext context) =>
      AppLocalizations.of(context).title,
      title: 'Flutter Google SignIn',

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: _testValue?
      LoginScreen(user:currentUser):
      LoginWithRestfulApi(),
    );
  }
}





/*
class MyApp extends StatelessWidget {
  // This widget is the root of your application.



  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ""),
        Locale('es', ''),
      ],
      onGenerateTitle: (BuildContext context) =>
      AppLocalizations.of(context).title,
      title: 'Flutter Google SignIn',

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home:

      LoginWithRestfulApi(),
    );
  }
}
*/









