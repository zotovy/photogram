import 'package:flutter/material.dart';
import 'package:photogram/ui/screens/search_action.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  GlobalKey<FormState> _searchFormKey = GlobalKey<FormState>();

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
      child: Form(
        key: _searchFormKey,
        child: TextFormField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
              hoverColor: Colors.blueAccent,
              suffixIcon: GestureDetector(
                child: Icon(Icons.search),
                onTap: () {
                  if (_searchFormKey.currentState.validate()) {
                    _searchFormKey.currentState.save();
                  }
                },
              ),
              hintText: 'Search',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            validator: (value) =>
                value.trim().length < 1 ? 'Invalid value' : null,
            onSaved: (value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchActionPage(searchText: value),
                  ),
                )),
      ),
    );
  }

  Widget _buildPost() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(
              'https://instagram.fhrk1-1.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/s750x750/56887239_274737130147897_1115729614862582493_n.jpg?_nc_ht=instagram.fhrk1-1.fna.fbcdn.net&_nc_cat=101&_nc_ohc=ODRiIj2Ad0QAX-jkh-X&oh=b7701356b9a332d2f78ca1c9bf8799fa&oe=5EA5412A',
            ),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(1, 3),
              blurRadius: 5,
              color: Color.fromARGB(35, 0, 0, 0),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSquarePost() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        height: MediaQuery.of(context).size.width / 2 - 34,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(
              'https://instagram.fhrk1-1.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/s750x750/56887239_274737130147897_1115729614862582493_n.jpg?_nc_ht=instagram.fhrk1-1.fna.fbcdn.net&_nc_cat=101&_nc_ohc=ODRiIj2Ad0QAX-jkh-X&oh=b7701356b9a332d2f78ca1c9bf8799fa&oe=5EA5412A',
            ),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(1, 3),
              blurRadius: 5,
              color: Color.fromARGB(35, 0, 0, 0),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ListView(
        children: <Widget>[
          _buildAppBar(),
          SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 28, right: 6),
                width: MediaQuery.of(context).size.width / 2,
                child: Column(
                  children: <Widget>[
                    _buildPost(),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 28, left: 6),
                width: MediaQuery.of(context).size.width / 2,
                child: Column(
                  children: <Widget>[
                    _buildPost(),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }
}
