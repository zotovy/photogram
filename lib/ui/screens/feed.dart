import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:photogram/models/post.dart';
import 'package:photogram/models/user.dart';
import 'package:photogram/models/userData.dart';
import 'package:photogram/services/auth.dart';
import 'package:photogram/services/database.dart';
import 'package:photogram/utilities/constants.dart';
import 'package:photogram/widgets/post.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<Post> _posts = [];

  _setupPosts() async {
    List<Post> answer = await DatabaseService.getFeddedPost(
        Provider.of<UserData>(context, listen: false).currentUserId);
    setState(() {
      _posts = answer;
    });
  }

  @override
  void initState() {
    super.initState();
    _setupPosts();
  }

  Future<void> refresh() async {
    _setupPosts();
  }

  Widget _buildPosts() {
    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: _posts.length,
        itemBuilder: (BuildContext context, int i) {
          Post post = _posts[i];
          return PostViewWidget(post: post);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _posts.length == 0
        ? RaisedButton(
            child: Text('logout'),
            color: Colors.blueAccent,
            onPressed: AuthService.logout,
          )
        : _buildPosts();
  }
}
