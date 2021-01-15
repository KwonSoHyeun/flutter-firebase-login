import 'package:flutter/material.dart';
//import 'google_signin/google_signin_demo.dart';
import 'package:provider/provider.dart';
import 'firebase_provider.dart';
import 'mail/auth_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ignore: missing_required_param
        ChangeNotifierProvider(create: (context) => FirebaseProvider())
      ],
      child: MaterialApp(
        title: "Flutter Firebase",
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter Firebase")),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Google Sign-In Demo"),
            subtitle: Text("google_sign_in Plugin"),
            onTap: () {
              //  Navigator.push(context,
              //      MaterialPageRoute(builder: (context) => GoogleSignInDemo()));
            },
          ),
          ListTile(
            title: Text("Firebase Auth"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AuthPage()));
            },
          )
        ].map((child) {
          return Card(
            child: child,
          );
        }).toList(),
      ),
    );
  }
}
