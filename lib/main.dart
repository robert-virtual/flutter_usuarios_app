import 'package:flutter/material.dart';
import 'package:flutter_usuarios_app/models/usuario.dart';
import 'package:flutter_usuarios_app/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Usuarios App',
      home: HomePage(),
    );
  }
}
