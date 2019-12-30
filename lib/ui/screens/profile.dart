import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:photogram/models/user.dart';
import 'package:photogram/ui/screens/editProfile.dart';
import 'package:photogram/utilities/constants.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  ProfileScreen({this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Text('lil__niki_'),
      leading: GestureDetector(
        child: Icon(
          Icons.arrow_back,
          color: Colors.grey,
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 15),
          child: Icon(Icons.more_horiz),
        )
      ],
    );
  }

  Widget _buildUI(User user) {
    return ListView(
      children: <Widget>[
        SizedBox(height: 35),
        Row(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    user.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    user.profession,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  Text(
                    user.bio,
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  Text(
                    user.bioLink,
                    style: TextStyle(color: Colors.blueAccent, fontSize: 14),
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 25),
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      '280',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      '407',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
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
        SizedBox(height: 25),
        Padding(
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
        ),
        SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 25),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(1, 3),
                        blurRadius: 5,
                        color: Color.fromARGB(35, 0, 0, 0),
                      )
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 25,
                    child: Icon(
                      MdiIcons.hockeySticks,
                      color: Colors.white,
                    ),
                    // backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1514511719-9f5849dc16d0?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1934&q=80'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 25),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(1, 3),
                        blurRadius: 5,
                        color: Color.fromARGB(35, 0, 0, 0),
                      )
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 25,
                    child: Icon(
                      MdiIcons.city,
                      color: Colors.white,
                    ),
                    backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1514511719-9f5849dc16d0?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1934&q=80'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 25),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(1, 3),
                        blurRadius: 5,
                        color: Color.fromARGB(35, 0, 0, 0),
                      )
                    ],
                  ),
                  child: CircleAvatar(
                    child: Icon(
                      MdiIcons.artist,
                      color: Colors.white,
                    ),
                    radius: 25,
                    backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1558981285-501cd9af9426?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80'),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(1, 3),
                        blurRadius: 5,
                        color: Color.fromARGB(35, 0, 0, 0),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                      height: MediaQuery.of(context).size.width - 72,
                      width: MediaQuery.of(context).size.width - 72,
                      image: NetworkImage(
                          'https://instagram.fhrk1-1.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/s750x750/56887239_274737130147897_1115729614862582493_n.jpg?_nc_ht=instagram.fhrk1-1.fna.fbcdn.net&_nc_cat=101&_nc_ohc=ODRiIj2Ad0QAX-jkh-X&oh=b7701356b9a332d2f78ca1c9bf8799fa&oe=5EA5412A'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(1, 3),
                        blurRadius: 5,
                        color: Color.fromARGB(35, 0, 0, 0),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                      height: MediaQuery.of(context).size.width - 72,
                      width: MediaQuery.of(context).size.width - 72,
                      image: NetworkImage(
                          'https://instagram.fhrk1-1.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/s750x750/72098398_432294131025323_6256807535595697372_n.jpg?_nc_ht=instagram.fhrk1-1.fna.fbcdn.net&_nc_cat=111&_nc_ohc=gd2P3-hS1poAX-_tqzG&oh=7de9875b74e391d8f7474d5a9fa7de92&oe=5E9D5E58'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(1, 3),
                        blurRadius: 5,
                        color: Color.fromARGB(35, 0, 0, 0),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                      height: MediaQuery.of(context).size.width - 72,
                      width: MediaQuery.of(context).size.width - 72,
                      image: NetworkImage(
                          'https://instagram.fhrk1-1.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/s750x750/73291647_2167673173536721_6008377497148947799_n.jpg?_nc_ht=instagram.fhrk1-1.fna.fbcdn.net&_nc_cat=101&_nc_ohc=oPBC5YCUKlEAX85P_j1&oh=9b557ff848e41669832ece6659cd03ac&oe=5EA9F0DD'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: userRef.document(widget.userId).get(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            User user = User.fromDoc(snapshot.data);
            print(user.username);
            return _buildUI(user);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
