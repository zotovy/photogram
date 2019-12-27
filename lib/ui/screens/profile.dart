import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(height: 35),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://sun9-33.userapi.com/c857628/v857628208/58d6a/Z8Z2-n_qy9A.jpg?ava=1'),
                ),
              ),
              Container(
                height: 85,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'lil__niki_',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Photography',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    Text(
                      'Photographer',
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                    Text(
                      'f3.cool/lil__niki_?hl=ru',
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        '407',
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
                  onTap: () => print('edit profile'),
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
                      backgroundImage: NetworkImage(
                          'https://instagram.frix7-1.fna.fbcdn.net/v/t51.12442-15/e35/c0.316.720.720a/s150x150/44199537_753282781680819_4523358947951725771_n.jpg?_nc_ht=instagram.frix7-1.fna.fbcdn.net&_nc_cat=103&_nc_ohc=NUnC0ISeV9EAX8cN1VZ&oh=42121731776e0cc588d4de8462364066&oe=5E09051B'),
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
                          'https://instagram.frix7-1.fna.fbcdn.net/v/t51.12442-15/e35/c0.472.1080.1080a/s150x150/43913802_2144987975753491_7936002635914018451_n.jpg?_nc_ht=instagram.frix7-1.fna.fbcdn.net&_nc_cat=107&_nc_ohc=-uBfkQst78AAX_vsZuv&oh=8414e068b3d9b18b9224d9b27e5b70eb&oe=5E08E00A'),
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
                          'https://instagram.frix7-1.fna.fbcdn.net/v/t51.12442-15/e35/c0.473.1080.1080a/s150x150/40260697_258786971414989_1000543001316950016_n.jpg?_nc_ht=instagram.frix7-1.fna.fbcdn.net&_nc_cat=101&_nc_ohc=XPZ-ZLyG7pUAX8hhX41&oh=09ce3b5ec187616729240df4e9b513a0&oe=5E08A57A'),
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
      ),
    );
  }
}
