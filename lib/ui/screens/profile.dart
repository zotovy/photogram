import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:photogram/models/post.dart';
import 'package:photogram/models/user.dart';
import 'package:photogram/models/userData.dart';
import 'package:photogram/services/database.dart';
import 'package:photogram/ui/screens/editProfile.dart';
import 'package:photogram/ui/screens/showFollowers.dart';
import 'package:photogram/ui/screens/showFollowing.dart';
import 'package:photogram/utilities/constants.dart';
import 'package:photogram/widgets/post.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  final String currentUserId;

  ProfileScreen({this.userId, this.currentUserId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isFollowing = true;
  int _followerCounter;
  int _followingCounter;
  List<Post> _posts = [];

  _setupIsFollowing() async {
    bool answer = await DatabaseService.isFollowing(
        currentUserId: widget.currentUserId, userId: widget.userId);
    setState(() {
      _isFollowing = answer;
    });
  }

  _setupFollowing() async {
    int answer = await DatabaseService.countFollowing(widget.userId);
    setState(() {
      _followingCounter = answer;
    });
  }

  _setupFollowers() async {
    int answer = await DatabaseService.countFollowers(widget.userId);
    setState(() {
      _followerCounter = answer;
    });
  }

  _setupPosts() async {
    List<Post> posts = await DatabaseService.getUserPosts(widget.userId);
    if (mounted) {
      setState(() {
        _posts = posts;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _setupIsFollowing();
    _setupFollowing();
    _setupFollowers();
    _setupPosts();
  }

  _followOrUnfollow() {
    if (_isFollowing) {
      // Unfollow
      DatabaseService.unfollowUser(
          currentUserId: widget.currentUserId, userId: widget.userId);
      setState(() {
        _isFollowing = false;
        _followerCounter--;
      });
    } else {
      DatabaseService.followUser(
          currentUserId: widget.currentUserId, userId: widget.userId);
      setState(() {
        _isFollowing = true;
        _followerCounter++;
      });
    }
  }

  Widget _buildFollowButton(User user) {
    return _isFollowing
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Container(
              width: double.infinity,
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(3, 5),
                    blurRadius: 5,
                    color: Color.fromARGB(25, 0, 0, 0),
                  )
                ],
                color: Colors.grey,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => print('call dialog'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Following',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 7),
                      Icon(Icons.keyboard_arrow_down, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Container(
              width: double.infinity,
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(3, 5),
                    blurRadius: 5,
                    color: Color.fromARGB(25, 0, 0, 0),
                  )
                ],
                gradient: LinearGradient(
                  colors: [Color(0xFF50c9c3), Color(0xFF50A7C2)],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _followOrUnfollow,
                  child: Center(
                    child: Text(
                      'Follow',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Widget _buildButton(User user) {
    return user.id == Provider.of<UserData>(context).currentUserId
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Container(
              width: double.infinity,
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(3, 5),
                    blurRadius: 5,
                    color: Color.fromARGB(25, 0, 0, 0),
                  )
                ],
                gradient: LinearGradient(
                  colors: [Color(0xFF4F7CE3), Color(0xFF6E72E7)],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(user: user),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Edit profile',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          )
        : _buildFollowButton(user);
  }

  Widget _buildUpRow(User user) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.black12,
            backgroundImage: user.profileImageUrl.isEmpty
                ? AssetImage('assets/images/user_placeholder_image.jpg')
                : CachedNetworkImageProvider(user.profileImageUrl),
          ),
        ),
        Container(
          height: 85,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              user.profession.isEmpty
                  ? SizedBox.shrink()
                  : Text(
                      user.profession,
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
              user.bio.isEmpty
                  ? SizedBox.shrink()
                  : Text(
                      user.bio,
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
              user.bioLink.isEmpty
                  ? SizedBox.shrink()
                  : Text(
                      user.bioLink,
                      style: TextStyle(color: Colors.blueAccent, fontSize: 14),
                    )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo(User user) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Container(
            color: Colors.black12,
            height: 1,
            width: double.infinity,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      '13',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'posts',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w300),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ShowFollowersPage(
                      userId: user.id,
                      counFollowers: _followerCounter,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        _followerCounter.toString(),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'followers',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ShowFollowingPage(
                      userId: user.id,
                      counFollowers: _followerCounter,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        _followingCounter.toString(),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'following',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Container(
            color: Colors.black12,
            height: 1,
            width: double.infinity,
          ),
        ),
      ],
    );
  }

  Widget _buildPosts(List<Post> posts) {
    return Column(
      children: List.generate(posts.length, (int i) {
        return PostViewWidget(post: posts[i]);
      }),
    );
  }

  Widget _buildUI(User user) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: ListView(
        children: <Widget>[
          _buildButton(user),
          SizedBox(height: 25),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: userRef.document(widget.userId).get(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data != null) {
              User user = User.fromDoc(snapshot.data);
              return ListView(children: <Widget>[
                SizedBox(height: 35),
                _buildUpRow(user),
                SizedBox(height: 25),
                _buildUserInfo(user),
                SizedBox(height: 25),
                _buildButton(user),
                SizedBox(height: 25),
                _buildPosts(_posts),
              ]);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
