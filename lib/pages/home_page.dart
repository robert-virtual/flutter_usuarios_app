import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_usuarios_app/models/usuario.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final url = Uri.parse("http://10.0.2.2:3030/usuarios");
  final headers = {"Content-Type": "application/json;charset=UTF-8"};
  late Future<List<Usuario>> usuarios;
  final nombre = TextEditingController();
  final email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios App'),
      ),
      body: FutureBuilder<List<Usuario>>(
          future: usuarios,
          builder: (context, snap) {
            if (snap.hasData) {
              return ListView.builder(
                  itemCount: snap.data!.length,
                  itemBuilder: (context, i) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(snap.data![i].nombre),
                          subtitle: Text(snap.data![i].email),
                        ),
                        const Divider()
                      ],
                    );
                  });
            }
            if (snap.hasError) {
              return const Center(
                child: Text("Ups ha habido un error"),
              );
            }

            return const CircularProgressIndicator();
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: showForm,
        child: const Icon(Icons.add),
      ),
    );
  }

  void showForm() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Agregar Usuario"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombre,
                  decoration: const InputDecoration(hintText: "Nombre"),
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: email,
                  decoration: const InputDecoration(hintText: "Email"),
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  saveUsuario();
                  Navigator.of(context).pop();
                },
                child: const Text("Guardar"),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    usuarios = getUsuarios();
  }

  Future<List<Usuario>> getUsuarios() async {
    final res = await http.get(url); //texto
    final lista = List.from(jsonDecode(res.body));

    List<Usuario> usuarios = [];
    lista.forEach((element) {
      final Usuario user = Usuario.fromJson(element);
      usuarios.add(user);
    });
    return usuarios.reversed.toList();
  }

  void saveUsuario() async {
    final user = {"nombre": nombre.text, "email": email.text};
    await http.post(url, headers: headers, body: jsonEncode(user));
    nombre.clear();
    email.clear();
    setState(() {
      usuarios = getUsuarios();
    });

  }
}
