import 'package:flutter/material.dart';
import 'package:photogram/services/auth.dart';

class FeedPage extends StatefulWidget {
  static final id = 'feed_page';

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Feed screen'),
            FlatButton(
              color: Colors.blueAccent,
              child: Text('Logout'),
              onPressed: () {
                AuthService.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
