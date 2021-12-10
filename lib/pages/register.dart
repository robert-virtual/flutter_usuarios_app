import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_usuarios_app/models/usuario.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}


class _RegisterPageState extends State<RegisterPage> {
final storage = const FlutterSecureStorage();
final nombre = TextEditingController();
final email = TextEditingController();
final clave = TextEditingController();
final clave2 = TextEditingController();
final url = Uri.parse("http://10.0.2.2:3030/usuarios");

final headers = {"Content-Type": "application/json;charset=UTF-8"};

String? claveError;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Text(
                "Social",
                style: TextStyle(
                    fontSize: 50, color: Theme.of(context).primaryColor),
              ),
              const Text(
                "Registro",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: nombre,
                  decoration: const InputDecoration(
                      hintText: "Nombre", border: InputBorder.none),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: email,
                  decoration: const InputDecoration(
                      hintText: "Email", border: InputBorder.none),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                child: TextField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: clave,
                  decoration: InputDecoration(
                      errorText: claveError,
                      hintText: "Contraseña",
                      border: InputBorder.none),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                child: TextField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: clave2,
                  decoration: const InputDecoration(
                      hintText: "Confirmar Contraseña",
                      border: InputBorder.none),
                ),
              ),
              ElevatedButton(
                  onPressed: register, child: const Text("Crear cuenta")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("login");
                  },
                  child: const Text("Ya tengo una cuenta"))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> register() async {
    if (clave.text != clave2.text) {
      setState(() {
        claveError = "Contraseñas no coinciden";
      });
      return;
    }
    setState(() {
      claveError = null;
    });

    final user = {
      "nombre": nombre.text,
      "email": email.text,
      "password": clave.text
    };
    final res = await http.post(url, headers: headers, body: jsonEncode(user));

    if (res.statusCode == 401) {
      final data = Map.from((jsonDecode(res.body)));
      showSnackBar(data["error"]);
      return;
    }

    if (res.statusCode != 200) {
      showSnackBar("Ups hubo un error, intente de nuevo");
      return;
    }
    final data = Map.from(jsonDecode(res.body));
    final usuario = Usuario.fromJson(data);
    await storage.write(key: 'refresh-token', value: usuario.refreshToken);
    await storage.write(key: 'access-token', value: usuario.refreshToken);
    Navigator.of(context).pushNamed('home');
  }

  void showSnackBar(String msg) {
    final snack = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }
}
