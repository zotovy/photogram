import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photogram/models/user.dart';
import 'package:photogram/models/userData.dart';
import 'package:photogram/services/database.dart';
import 'package:provider/provider.dart';

class ShowFollowersPage extends StatefulWidget {
  final String userId;
  final int counFollowers;

  ShowFollowersPage({this.userId, this.counFollowers});

  @override
  _ShowFollowersPageState createState() => _ShowFollowersPageState();
}

class _ShowFollowersPageState extends State<ShowFollowersPage> {
  _showAlert(User user) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Remove follower ${user.username}?"),
          content: new Text(
              "I won't tell @${user.username} that they have been removed from your followers"),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                DatabaseService.unfollowUser(
                  currentUserId: Provider.of<UserData>(
                    context,
                    listen: false,
                  ).currentUserId,
                  userId: user.id,
                );
                Navigator.pop(context);
              },
              child: Text("Yes"),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.pop(context),
              child: Text("No"),
            )
          ],
        );
      },
    );
  }

  Widget _buildUserTile(User user) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.black12,
        backgroundImage: user.profileImageUrl.isEmpty
            ? AssetImage('assets/images/user_placeholder_image.jpg')
            : CachedNetworkImageProvider(user.profileImageUrl),
      ),
      title: Text(user.username),
      subtitle: Text(user.name),
      trailing: widget.userId ==
              Provider.of<UserData>(
                context,
                listen: false,
              ).currentUserId
          ? IconButton(
              icon: Icon(Icons.more_vert), onPressed: () => _showAlert(user))
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text('Followers'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black38),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder(
        future: DatabaseService.getFollowers(widget.userId),
        builder: (BuildContext context, snapshot) {
          if (snapshot.data != null && snapshot.hasData) {
            return snapshot.data.length == 0
                ? Center(
                    child: Text('No followers:('),
                  )
                : ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int i) {
                      User user = snapshot.data[i];
                      return _buildUserTile(user);
                    },
                  );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
