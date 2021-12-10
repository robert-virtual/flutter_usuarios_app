import 'package:flutter/material.dart';
import 'package:flutter_usuarios_app/pages/home_page.dart';
import 'package:flutter_usuarios_app/pages/login.dart';
import 'package:flutter_usuarios_app/pages/register.dart';
import 'package:flutter_usuarios_app/pages/splash.dart';

void main() => runApp(MyApp());



class MyApp extends StatelessWidget {
 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Usuarios App',
      initialRoute: 
      "splash",
      routes: {
        "splash": (context) => SplashPage(),
        "login": (context) => LoginPage(),
        "register": (context) => RegisterPage(),
        "home": (context) => HomePage()
      },
    );
  }
}
