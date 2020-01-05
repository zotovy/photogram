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
  final String currentUserId;

  FeedPage({this.currentUserId});

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  Future<List<Post>> _posts;

  @override
  void initState() {
    super.initState();
    _setupPosts();
  }

  _setupPosts() async {
    _posts = DatabaseService.getFeddedPost(
      Provider.of<UserData>(context, listen: false).currentUserId,
    );
  }

  Future<void> refresh() async {
    if (mounted) {
      _setupPosts();
    }
  }

  Widget _appBar() {
    var appBar = AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      title: Text(
        'Photogram',
        style: TextStyle(fontFamily: 'BeautyMountains', fontSize: 24),
      ),
    );
    return appBar;
  }

  Widget _buildPosts() {
    return RefreshIndicator(
      onRefresh: refresh,
      child: FutureBuilder(
        future: _posts,
        builder: (BuildContext context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
              break;
            default:
              if (snapshot.hasError) {
                return Center(
                    child: Container(child: Text(snapshot.error.toString())));
              }
              if (snapshot.data.length == 0) {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("You havent't any feeded posts:)"),
                    Text('Please, follow someone.')
                  ],
                ));
              }
              return ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int i) {
                  Post post = snapshot.data[i];
                  return PostViewWidget(post: post);
                },
              );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _buildPosts(),
    );
  }
}
