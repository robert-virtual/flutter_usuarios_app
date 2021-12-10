
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late String? accessToken;
  final storage = const FlutterSecureStorage();

  

  Future<void> lookupToken() async {
    accessToken = await storage.read(key: 'access-token');
    if (accessToken != null) {
      Navigator.of(context).pushNamed("home");
      return;
    }
    Navigator.of(context).pushNamed("login");
  }

  @override
  Widget build(BuildContext context) {
    lookupToken();

    return Scaffold(
      body: Center(
        child: Text(
          "Social",
          style: TextStyle(fontSize: 50, color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}
