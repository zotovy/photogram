import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:photogram/models/userData.dart';
import 'package:photogram/ui/screens/feed.dart';
import 'package:photogram/ui/screens/activity.dart';
import 'package:photogram/ui/screens/profile.dart';
import 'package:photogram/ui/screens/search.dart';
import 'package:photogram/ui/screens/search_action.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static final String id = 'home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentPage = 0;
  List<Widget> _pages;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pages = [
      FeedPage(),
      SearchActionPage(searchText: ''),
      ActivityScreen(
        userId: Provider.of<UserData>(context, listen: false).currentUserId,
      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              onPressed: () => setState(() {
                _currentPage = 0;
                _pageController.jumpToPage(_currentPage);
              }),
              icon: Icon(MdiIcons.home),
              color: _currentPage == 0 ? Colors.black : Colors.black26,
            ),
            IconButton(
                onPressed: () => setState(() {
                      _currentPage = 1;
                      _pageController.jumpToPage(_currentPage);
                    }),
                icon: Icon(Icons.search),
                color: _currentPage == 1 ? Colors.black : Colors.black26),
            IconButton(
                onPressed: () => setState(() {
                      _currentPage = 2;
                      _pageController.jumpToPage(_currentPage);
                    }),
                icon: Icon(MdiIcons.heart),
                color: _currentPage == 2 ? Colors.black : Colors.black26),
            IconButton(
                onPressed: () => setState(() {
                      _currentPage = 3;
                      _pageController.jumpToPage(_currentPage);
                    }),
                icon: Icon(Icons.person),
                color: _currentPage == 3 ? Colors.black : Colors.black26),
          ],
        ),
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
          width: 56,
          height: 56,
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
