import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photogram/models/user.dart';
import 'package:photogram/models/userData.dart';
import 'package:photogram/services/database.dart';
import 'package:photogram/ui/screens/profile.dart';
import 'package:provider/provider.dart';

class ShowFollowingPage extends StatefulWidget {
  final String userId;
  final int counFollowers;

  ShowFollowingPage({this.userId, this.counFollowers});

  @override
  _ShowFollowingPageState createState() => _ShowFollowingPageState();
}

class _ShowFollowingPageState extends State<ShowFollowingPage> {
  Widget _buildUserTile(User user) {
    return ListTile(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProfileScreen(
            userId: user.id,
            currentUserId: Provider.of<UserData>(
              context,
              listen: false,
            ).currentUserId,
          ),
        ),
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.black12,
        backgroundImage: user.profileImageUrl.isEmpty
            ? AssetImage('assets/images/user_placeholder_image.jpg')
            : CachedNetworkImageProvider(user.profileImageUrl),
      ),
      title: Text(user.username),
      subtitle: Text(user.name),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text('Following'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black38),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder(
        future: DatabaseService.getFollowing(widget.userId),
        builder: (BuildContext context, snapshot) {
          if (snapshot.data != null && snapshot.hasData) {
            return snapshot.data.length == 0
                ? Center(
                    child: Text('No following:('),
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
