import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_usuarios_app/models/usuario.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //texfields
  final email = TextEditingController();
  final clave = TextEditingController();
  //texfields

  final storage = const FlutterSecureStorage();
  //http
  final url = Uri.parse("http://10.0.2.2:3030/usuarios/login");
  final headers = {"Content-Type": "application/json;charset=UTF-8"};
  //http
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Social",
            style:
                TextStyle(fontSize: 50, color: Theme.of(context).primaryColor),
          ),
          const Text(
            "Inicio de session",
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: email,
              decoration: const InputDecoration(
                  hintText: "Email", border: InputBorder.none),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: clave,
              decoration: const InputDecoration(
                  hintText: "Clave", border: InputBorder.none),
            ),
          ),
          ElevatedButton(
            onPressed: login,
            child: const Text("Entrar"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed("register");
              },
              child: const Text("Crear cuenta"))
        ],
      ),
    );
  }

  void showSnackbar(String msg) {
    final snack = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  Future<void> login() async {
    if (email.text.isEmpty || clave.text.isEmpty) {
      showSnackbar(
          "${email.text.isEmpty ? "-Email " : ""} ${clave.text.isEmpty ? "-Clave" : ""} requerido");
      return;
    }
    final user = {"email": email.text, "clave": clave.text};
    final res = await http.post(url, headers: headers, body: jsonEncode(user));
    final data = Map.from(jsonDecode(res.body));
    if (res.statusCode == 400) {
      showSnackbar(data["error"]);
      return;
    }
    if (res.statusCode != 200) {
      showSnackbar("Ups ha habido un error");
    }
    final usuario = Usuario.fromJson(data);
    await storage.write(key: 'refresh-token', value: usuario.refreshToken);
    await storage.write(key: 'access-token', value: usuario.refreshToken);
    Navigator.of(context).pushNamed('home');
  }
}
