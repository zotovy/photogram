import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:photogram/models/post.dart';
import 'package:photogram/models/user.dart';
import 'package:photogram/models/userData.dart';
import 'package:photogram/services/database.dart';
import 'package:provider/provider.dart';

class PostViewWidget extends StatefulWidget {
  final Post post;

  PostViewWidget({this.post});

  @override
  _PostViewWidgetState createState() => _PostViewWidgetState();
}

class _PostViewWidgetState extends State<PostViewWidget> {
  int _likeCount = 0;
  bool _isLiked = false;
  bool _isFav = false;
  User _user;

  _initPostLiked() async {
    bool isLiked = await DatabaseService.isLikedPost(
      userId: Provider.of<UserData>(context, listen: false).currentUserId,
      postId: widget.post.id,
    );
    if (mounted) {
      setState(() {
        _isLiked = isLiked;
      });
    }
  }

  _initIsFav() async {
    bool isFav = await DatabaseService.isFavPost(
      userId: Provider.of<UserData>(context, listen: false).currentUserId,
      postId: widget.post.id,
    );
    if (mounted) {
      setState(() {
        _isFav = isFav;
      });
    }
  }

  _initPost() async {
    User user = await DatabaseService.getUserById(widget.post.authorId);
    if (mounted) {
      setState(() {
        _user = user;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _likeCount = widget.post.likeCount;
    _initPostLiked();
    _initPost();
    _initIsFav();
  }

  _likePost() {
    if (_isLiked) {
      // Unlike Post
      DatabaseService.unlikePost(
        userId: Provider.of<UserData>(context, listen: false).currentUserId,
        post: widget.post,
      );
      setState(() {
        _isLiked = false;
        _likeCount = _likeCount - 1;
      });
    } else {
      // Like Post
      DatabaseService.likePost(
        userId: Provider.of<UserData>(context, listen: false).currentUserId,
        post: widget.post,
      );
      setState(() {
        _isLiked = true;
        _likeCount = _likeCount + 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      _user != null
                          ? Container(
                              margin: EdgeInsets.only(bottom: 5),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    _user.profileImageUrl,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 3),
                                      blurRadius: 5,
                                      color: Colors.black26)
                                ],
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black12,
                              ),
                            ),
                      SizedBox(width: 15),
                      _user != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '@' + _user.username,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    shadows: [
                                      Shadow(
                                          offset: Offset(1, 1),
                                          blurRadius: 2,
                                          color: Colors.black26)
                                    ],
                                  ),
                                ),
                                Text(
                                  _user.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.more_horiz),
                    color: Colors.grey,
                    onPressed: () => print('more'),
                  ),
                ],
              )),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            width: MediaQuery.of(context).size.width - 56,
            height: MediaQuery.of(context).size.width - 56,
            decoration: BoxDecoration(
              color: Colors.white,
              image: widget.post.imagesUrl.length == 1
                  ? DecorationImage(
                      image:
                          CachedNetworkImageProvider(widget.post.imagesUrl[0]),
                      fit: BoxFit.cover,
                    )
                  : null,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  offset: Offset(1, 5),
                  blurRadius: 7,
                  color: Colors.black26,
                ),
              ],
            ),
            child: widget.post.imagesUrl.length == 1
                ? null
                : PageView.builder(
                    itemCount: widget.post.imagesUrl.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Container(
                        width: MediaQuery.of(context).size.width - 56,
                        height: MediaQuery.of(context).size.width - 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                widget.post.imagesUrl[i]),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              child: Text(
                                (i + 1).toString() +
                                    '/' +
                                    widget.post.imagesUrl.length.toString(),
                              ),
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      _isLiked ? MdiIcons.heart : MdiIcons.heartOutline,
                      color: Colors.black45,
                    ),
                    onPressed: _likePost,
                  ),
                  SizedBox(width: 5),
                  Text(_likeCount.toString()),
                ],
              ),
              IconButton(
                icon: Icon(_isFav ? Icons.bookmark : Icons.bookmark_border),
                color: _isFav ? Color(0xFFf48b4a) : Colors.black38,
                onPressed: () {
                  if (_isFav) {
                    DatabaseService.deleteFavPost(
                        postId: widget.post.id,
                        userId: Provider.of<UserData>(context, listen: false)
                            .currentUserId);
                    setState(() {
                      _isFav = false;
                    });
                  } else {
                    DatabaseService.createFavPost(
                        postId: widget.post.id,
                        userId: Provider.of<UserData>(context, listen: false)
                            .currentUserId);
                    setState(() {
                      _isFav = true;
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
