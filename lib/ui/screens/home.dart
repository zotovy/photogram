import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:photogram/models/userData.dart';
import 'package:photogram/ui/screens/notification.dart';
import 'package:photogram/ui/screens/profile.dart';
import 'package:photogram/ui/screens/search.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static final String id = 'home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentPage = 1;
  List<Widget> _pages;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pages = [
      _homePage(),
      SearchScreen(),
      NotificationScreen(),
      ProfileScreen(
        userId: Provider.of<UserData>(context, listen: false).currentUserId,
        currentUserId:
            Provider.of<UserData>(context, listen: false).currentUserId,
      ),
    ];
    _pageController = PageController();
  }

  Widget _buildStoriesBox() {
    return Padding(
      padding: EdgeInsets.only(right: 16),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: Colors.blueAccent),
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1, color: Colors.white),
          ),
          width: 47,
          height: 47,
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/logo.png'),
          ),
        ),
      ),
    );
  }

  Widget _homePage() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Row(
            children: <Widget>[
              // TODO: Stream builder
              _buildStoriesBox(),
              _buildStoriesBox(),
              _buildStoriesBox(),
            ],
          ),
        ),
        Container(
          height: 500,
          child: ListView.builder(
            itemCount: 100,
            itemBuilder: (context, i) {
              return ListTile(
                leading: Text('$i'),
              );
            },
          ),
        ),
      ],
    );
  }

  // Widget _appBar() {
  //   return AppBar(
  //     elevation: 0,
  //     backgroundColor: Colors.transparent,
  //     title: Text(
  //       'Photogram',
  //       style: TextStyle(fontFamily: 'BeautyMountains', fontSize: 24),
  //     ),
  //     actions: <Widget>[
  //       IconButton(
  //           icon: Icon(MdiIcons.telegram, color: Colors.black, size: 24),
  //           onPressed: () => print('go to direct')),
  //       IconButton(
  //           icon: Icon(MdiIcons.televisionClean, color: Colors.black, size: 24),
  //           onPressed: () => print('go to TV')),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentPage,
        backgroundColor: Colors.transparent,
        animationDuration: Duration(milliseconds: 200),
        items: [
          Icon(MdiIcons.home),
          Icon(Icons.search),
          Icon(MdiIcons.heart),
          Icon(Icons.person),
        ],
        onTap: (index) {
          setState(() {
            _currentPage = index;
          });
          _pageController.jumpToPage(index);
        },
      ),
      // appBar: _appBar(),
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (int index) {
          setState(() {
            _currentPage = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFFf48b4a), Color(0xFFca2b7e)],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          child: Icon(Icons.add),
        ),
        // backgroundColor: Color(0xFFca2b7e),
        onPressed: () => Navigator.pushNamed(context, 'createPost_page'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
