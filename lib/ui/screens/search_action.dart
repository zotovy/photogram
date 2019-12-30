import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:photogram/models/user.dart';
import 'package:photogram/services/database.dart';

class SearchActionPage extends StatefulWidget {
  static final String id = 'searchAction_page';

  String searchText;

  SearchActionPage({this.searchText});

  @override
  _SearchActionPageState createState() => _SearchActionPageState();
}

class _SearchActionPageState extends State<SearchActionPage> {
  TextEditingController _controller = TextEditingController();

  Future<QuerySnapshot> _users;

  @override
  void initState() {
    super.initState();
    _users = DatabaseService.searchUsers(widget.searchText);
    _controller.text = widget.searchText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _users == null
            ? Center(child: CircularProgressIndicator())
            : FutureBuilder(
                future: _users,
                builder: (BuildContext context, snap) {
                  if (!snap.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snap.data.documents.length == 0) {
                    return FloatingSearchBar.builder(
                      controller: _controller,
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 200),
                          child: Center(
                            child: Text('No user found:('),
                          ),
                        );
                      },
                      trailing: Icon(Icons.search),
                      onChanged: (String value) {
                        setState(() {
                          _users = DatabaseService.searchUsers(value);
                        });
                      },
                      onTap: () {},
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                        prefixIcon: GestureDetector(
                          child: Icon(Icons.arrow_back),
                          onTap: () => Navigator.pop(context),
                        ),
                        hintText: "Search",
                      ),
                    );
                  }

                  return FloatingSearchBar.builder(
                    controller: _controller,
                    itemCount: snap.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      User user = User.fromDoc(snap.data.documents[index]);
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.black12,
                          backgroundImage: user.profileImageUrl.isEmpty
                              ? AssetImage(
                                  'assets/images/user_placeholder_image.jpg')
                              : CachedNetworkImageProvider(
                                  user.profileImageUrl),
                        ),
                        title: Text(user.username),
                        subtitle: Text(user.name),
                      );
                    },
                    trailing: Icon(Icons.search),
                    onChanged: (String value) {
                      setState(() {
                        _users = DatabaseService.searchUsers(value);
                      });
                    },
                    onTap: () {},
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                      prefixIcon: GestureDetector(
                        child: Icon(Icons.arrow_back),
                        onTap: () => Navigator.pop(context),
                      ),
                      hintText: "Search",
                    ),
                  );
                },
              ));
  }
}
