import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photogram/models/userData.dart';
import 'package:photogram/ui/screens/createPost.dart';
import 'package:photogram/ui/screens/editProfile.dart';
import 'package:photogram/ui/screens/home.dart';

import 'package:photogram/ui/screens/login.dart';
import 'package:photogram/ui/screens/search_action.dart';
import 'package:photogram/ui/screens/signup.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Widget _getPage() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          Provider.of<UserData>(context).currentUserId = snapshot.data.uid;
          return HomePage();
        } else {
          return LoginPage();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Color(0xFFF48B4A), accentColor: Colors.blueAccent),
        home: _getPage(),
        routes: {
          LoginPage.id: (context) => LoginPage(),
          SignupPage.id: (context) => SignupPage(),
          HomePage.id: (context) => HomePage(),
          EditProfilePage.id: (context) => EditProfilePage(),
          SearchActionPage.id: (context) => SearchActionPage(),
          CreatePostPage.id: (context) => CreatePostPage(),
        },
      ),
    );
  }
}
