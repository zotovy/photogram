import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentPage = 1;
  List<Widget> _pages;
  bool _showCreateButton = true;

  @override
  void initState() {
    super.initState();
    _pages = [
      _homePage(),
      _searchPage(),
      _notificationPage(),
      _profilePage(),
    ];
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

  Widget _searchPage() {
    return Center(
      child: Icon(Icons.card_membership),
    );
  }

  Widget _notificationPage() {
    return Center(
      child: Icon(Icons.ac_unit),
    );
  }

  Widget _profilePage() {
    return Center(
      child: Icon(Icons.change_history),
    );
  }

  Widget _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        'Photogram',
        style: TextStyle(fontFamily: 'BeautyMountains', fontSize: 24),
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(MdiIcons.telegram, color: Colors.black, size: 24),
            onPressed: () => print('go to direct')),
        IconButton(
            icon: Icon(MdiIcons.televisionClean, color: Colors.black, size: 24),
            onPressed: () => print('go to TV')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
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
        },
      ),
      appBar: _appBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: _pages.elementAt(_currentPage),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFca2b7e),
        onPressed: () => print('pressed'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
