import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photogram/models/activity.dart';
import 'package:photogram/models/post.dart';
import 'package:photogram/models/user.dart';
import 'package:photogram/models/userData.dart';
import 'package:photogram/services/database.dart';
import 'package:photogram/ui/screens/detailPost.dart';
import 'package:photogram/ui/screens/profile.dart';

class ActivityScreen extends StatefulWidget {
  final String userId;

  ActivityScreen({this.userId});

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  Widget _buildLikingTile(Activity activity) {
    return FutureBuilder(
      future: DatabaseService.getUserById(activity.fromUserId),
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        User fromUser = snapshot.data;
        return FutureBuilder(
          future: DatabaseService.getPostById(
            postId: activity.accessoryDataId,
            authorId: activity.toUserId,
          ),
          builder: (BuildContext context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox(width: 40, height: 40);
            }
            Post post = snapshot.data;
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.black12,
                backgroundImage: fromUser.profileImageUrl.isEmpty
                    ? AssetImage('assets/images/user_placeholder_image.jpg')
                    : CachedNetworkImageProvider(fromUser.profileImageUrl),
              ),
              title: FutureBuilder(
                future: DatabaseService.getUserById(widget.userId),
                builder: (BuildContext context, snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox.shrink();
                  }
                  User currentUser = snapshot.data;
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfileScreen(
                          currentUserId: currentUser.id,
                          userId: activity.fromUserId,
                        ),
                      ),
                    ),
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: currentUser.username,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        TextSpan(text: '  '),
                        TextSpan(
                          text: 'liked your post',
                          style: TextStyle(color: Colors.black),
                        ),
                      ]),
                    ),
                  );
                },
              ),
              trailing: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black12,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(post.imagesUrl[0]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailPostPage(
                    post: post,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCommentTile(Activity activity) {
    return FutureBuilder(
      future: DatabaseService.getUserById(activity.fromUserId),
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        User fromUser = snapshot.data;
        return FutureBuilder(
          future: DatabaseService.getPostById(
            postId: activity.accessoryDataId,
            authorId: activity.toUserId,
          ),
          builder: (BuildContext context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox(width: 40, height: 40);
            }
            Post post = snapshot.data;
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.black12,
                backgroundImage: fromUser.profileImageUrl.isEmpty
                    ? AssetImage('assets/images/user_placeholder_image.jpg')
                    : CachedNetworkImageProvider(fromUser.profileImageUrl),
              ),
              title: FutureBuilder(
                future: DatabaseService.getUserById(widget.userId),
                builder: (BuildContext context, snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox.shrink();
                  }
                  User currentUser = snapshot.data;
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfileScreen(
                          currentUserId: currentUser.id,
                          userId: activity.fromUserId,
                        ),
                      ),
                    ),
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: currentUser.username,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        TextSpan(text: '  '),
                        TextSpan(
                          text: 'commented:  ' + activity.text,
                          style: TextStyle(color: Colors.black),
                        ),
                      ]),
                    ),
                  );
                },
              ),
              trailing: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black12,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(post.imagesUrl[0]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailPostPage(
                    post: post,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFollowingTile(Activity activity) {
    return FutureBuilder(
      future: DatabaseService.getUserById(activity.fromUserId),
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        User fromUser = snapshot.data;
        return FutureBuilder(
          future: DatabaseService.getUserById(widget.userId),
          builder: (BuildContext context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox.shrink();
            }
            User currentUser = snapshot.data;
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.black12,
                backgroundImage: fromUser.profileImageUrl.isEmpty
                    ? AssetImage('assets/images/user_placeholder_image.jpg')
                    : CachedNetworkImageProvider(fromUser.profileImageUrl),
              ),
              title: FutureBuilder(
                future: DatabaseService.getUserById(widget.userId),
                builder: (BuildContext context, snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox.shrink();
                  }
                  User currentUser = snapshot.data;
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfileScreen(
                          currentUserId: currentUser.id,
                          userId: activity.fromUserId,
                        ),
                      ),
                    ),
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: currentUser.username,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        TextSpan(text: '  '),
                        TextSpan(
                          text: 'started following you',
                          style: TextStyle(color: Colors.black),
                        ),
                      ]),
                    ),
                  );
                },
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(
                    currentUserId: currentUser.id,
                    userId: fromUser.id,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBody(List<Activity> docs) {
    return Column(
      children: List.generate(docs.length, (int i) {
        Activity activity = docs[i];
        if (activity.type == activitiesTypes.liking) {
          return _buildLikingTile(activity);
        }
        if (activity.type == activitiesTypes.comment) {
          return _buildCommentTile(activity);
        }
        if (activity.type == activitiesTypes.following) {
          return _buildFollowingTile(activity);
        }
        print('Invalid type of activity $i');
        return SizedBox.shrink();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: DatabaseService.getAllActivities(' ' + widget.userId),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data.length == 0) {
            return Center(
              child: Text("You haven't got any activities:)"),
            );
          }

          return ListView(
            children: <Widget>[
              _buildBody(snapshot.data),
            ],
          );
        },
      ),
    );
  }
}
