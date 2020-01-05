import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:photogram/models/comment.dart';
import 'package:photogram/models/post.dart';
import 'package:photogram/models/user.dart';
import 'package:photogram/models/userData.dart';
import 'package:photogram/services/database.dart';
import 'package:photogram/widgets/appbar_progressIndicator.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class DetailPostPage extends StatefulWidget {
  final Post post;

  DetailPostPage({this.post});

  @override
  _DetailPostPageState createState() => _DetailPostPageState();
}

class _DetailPostPageState extends State<DetailPostPage> {
  int _likeCount = 0;
  int _commentCount = 0;
  bool _isLiked = false;
  bool _isFav = false;

  User _user;
  User _author;

  List<Comment> _comments = [];
  List<Widget> _commentsWidgets = [];

  String _newCommentText = '';
  bool _isLoading = false;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  FocusNode _focusNode = FocusNode();
  TextEditingController _textEditingController = TextEditingController();

  _initCommentCount() async {
    int commentCount = await DatabaseService.countComments(widget.post.id);
    if (mounted) {
      setState(() {
        _commentCount = commentCount;
      });
    }
  }

  _initComments() async {
    List<Comment> comments =
        await DatabaseService.getCommentsByPostId(widget.post.id);
    if (mounted) {
      setState(() {
        _comments = comments;
      });
    }
  }

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

  _initAuthor() async {
    User user = await DatabaseService.getUserById(widget.post.authorId);
    if (mounted) {
      setState(() {
        _author = user;
      });
    }
  }

  _initUser() async {
    User user = await DatabaseService.getUserById(
        Provider.of<UserData>(context, listen: false).currentUserId);
    if (mounted) {
      setState(() {
        _user = user;
      });
    }
  }

  _likePost() {
    if (_isLiked) {
      // Unlike Post
      DatabaseService.unlikePost(
        userId: Provider.of<UserData>(context, listen: false).currentUserId,
        post: widget.post,
      );
      if (mounted) {
        setState(() {
          _isLiked = false;
          _likeCount -= 1;
        });
      }
    } else {
      // Like Post
      DatabaseService.likePost(
        userId: Provider.of<UserData>(context, listen: false).currentUserId,
        post: widget.post,
      );
      if (mounted) {
        setState(() {
          _isLiked = true;
          _likeCount += 1;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initPostLiked();
    _likeCount = widget.post.likeCount;
    _initAuthor();
    _initIsFav();
    _initUser();
    _initCommentCount();
    _initComments();
  }

  Future<Null> _refresh() async {
    _scaffoldKey.currentState?.initState();
    // _initPostLiked();
    // _likeCount = widget.post.likeCount;
    // _initAuthor();
    // _initIsFav();
    // _initCommentCount();
    // _initComments();
    return null;
  }

  _submit() {
    if (_formKey.currentState.validate() && _textEditingController.text != '') {
      _formKey.currentState.save();
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
      Comment comment = Comment(
        id: Uuid().v4(),
        authorId: Provider.of<UserData>(context, listen: false).currentUserId,
        postId: widget.post.id,
        text: _newCommentText,
        timestamp: Timestamp.fromDate(DateTime.now()),
      );
      DatabaseService.createComments(
        post: widget.post,
        userId: Provider.of<UserData>(context, listen: false).currentUserId,
        comment: comment,
      );
      _refresh();
      FocusScope.of(context).requestFocus(new FocusNode()); //remove focus
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _textEditingController.clear());
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } else {}
  }

  _deleteComment(Comment comment) {
    DatabaseService.deleteComment(commentId: comment.id, post: widget.post);
    _refresh();
  }

  Widget _buildImg(Post post) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1f2430),
        image: DecorationImage(
          image: CachedNetworkImageProvider(post.imagesUrl[0]),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 28),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.0),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      FutureBuilder(
                        future: DatabaseService.getUserById(post.authorId),
                        builder: (BuildContext context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.black26,
                            );
                          }

                          return Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.white),
                              shape: BoxShape.circle,
                              color: Colors.black26,
                              image: DecorationImage(
                                image: snapshot.data.profileImageUrl.isEmpty
                                    ? AssetImage(
                                        'assets/images/user_placeholder_image.jpg',
                                      )
                                    : CachedNetworkImageProvider(
                                        snapshot.data.profileImageUrl,
                                      ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        onPressed: () => print('more'),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  child: GestureDetector(
                    onDoubleTap: _likePost,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      width: MediaQuery.of(context).size.width - 56,
                      height: MediaQuery.of(context).size.width - 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        image: widget.post.imagesUrl.length == 1
                            ? DecorationImage(
                                image: CachedNetworkImageProvider(
                                    widget.post.imagesUrl[0]),
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
                                  height:
                                      MediaQuery.of(context).size.width - 56,
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
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
                                              widget.post.imagesUrl.length
                                                  .toString(),
                                        ),
                                        backgroundColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              _isLiked ? MdiIcons.heart : MdiIcons.heartOutline,
                              color: Colors.white,
                            ),
                            onPressed: _likePost,
                          ),
                          Text(
                            _likeCount.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                          IconButton(
                            icon: Icon(Icons.mode_comment),
                            color: Colors.white,
                            onPressed: () => null,
                          ),
                          Text(
                            _commentCount.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                            _isFav ? Icons.bookmark : Icons.bookmark_border),
                        color: Colors.white,
                        onPressed: () {
                          if (_isFav) {
                            DatabaseService.deleteFavPost(
                                postId: widget.post.id,
                                userId: Provider.of<UserData>(context,
                                        listen: false)
                                    .currentUserId);
                            if (mounted) {
                              setState(() {
                                _isFav = false;
                              });
                            }
                          } else {
                            DatabaseService.createFavPost(
                                postId: widget.post.id,
                                userId: Provider.of<UserData>(context,
                                        listen: false)
                                    .currentUserId);
                            if (mounted) {
                              setState(() {
                                _isFav = true;
                              });
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCommentTile(User user, Comment comment) {
    return ListTile(
      title: Text(
        user.username,
        style: TextStyle(color: Colors.grey),
      ),
      trailing: Provider.of<UserData>(context).currentUserId == comment.authorId
          ? IconButton(
              icon: Icon(Icons.close),
              color: Colors.white,
              onPressed: () {
                _deleteComment(comment);
              },
            )
          : null,
      subtitle: Text(
        comment.text,
        style: TextStyle(color: Colors.white),
      ),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          shape: BoxShape.circle,
          image: DecorationImage(
            image: user.profileImageUrl.isEmpty
                ? AssetImage(
                    'assets/images/user_placeholder_image.jpg',
                  )
                : CachedNetworkImageProvider(
                    user.profileImageUrl,
                  ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildComments(Post post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: FutureBuilder(
        future: DatabaseService.getCommentsAuthorByPostId(widget.post.id),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data.length != 0 &&
              _comments.length != 0) {
            return Column(
              children: List.generate(
                _comments.length + 1,
                (int i) {
                  if (i < _comments.length) {
                    try {
                      Comment comment = _comments[i];
                      return FutureBuilder(
                        future: DatabaseService.getUserById(comment.authorId),
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.hasData) {
                            User user = snapshot.data;
                            return _buildCommentTile(user, comment);
                          }
                          return SizedBox.shrink();
                        },
                      );
                    } catch (e) {
                      return SizedBox();
                    }
                  }
                  return SizedBox(height: 70);
                },
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTextForm(Post post) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.white,
      ),
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Form(
        key: _formKey,
        child: TextFormField(
          controller: _textEditingController,
          focusNode: _focusNode,
          validator: (value) => null,
          onSaved: (value) => _newCommentText = value,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black26,
                  image: DecorationImage(
                    image: _user == null || _user.profileImageUrl.isEmpty
                        ? AssetImage(
                            'assets/images/user_placeholder_image.jpg',
                          )
                        : CachedNetworkImageProvider(
                            _user.profileImageUrl,
                          ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            suffixIcon: Padding(
              padding: EdgeInsets.all(0),
              child: IconButton(
                icon: Icon(Icons.done),
                onPressed: _submit,
              ),
            ),
            hintText: 'Comment...',
            focusColor: Colors.white,
            fillColor: Colors.white,
            hoverColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(100),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(100),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Color(0xFF18041D),
          appBar: _isLoading ? MyLinearProgressIndicator() : null,
          body: Stack(
            children: <Widget>[
              ListView(
                children: <Widget>[
                  _buildImg(widget.post),
                  _buildComments(widget.post),
                ],
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: _buildTextForm(widget.post),
              ),
            ],
          ),
          // bottomNavigationBar: _buildTextForm(),
        ),
      ),
    );
  }
}
