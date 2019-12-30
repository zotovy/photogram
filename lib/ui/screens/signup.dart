import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photogram/services/auth.dart';
import 'package:photogram/widgets/appbar_progressIndicator.dart';

class SignupPage extends StatefulWidget {
  static final String id = 'signup_page';

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _usernameController = TextEditingController();
  String _email, _name, _password, _username;

  bool _isLoading = false;

  Future<bool> usernameCheck(String username) async {
    final result = await Firestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .getDocuments();
    return result.documents.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isLoading
          ? MyLinearProgressIndicator(
              backgroundColor: Colors.lightBlue,
            )
          : null,
      key: _scaffoldKey,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Image(image: AssetImage('assets/images/logo.png')),
              ),
              Form(
                key: _key,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 28),
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 15, right: 7),
                            child: Icon(
                              Icons.email,
                              color: Colors.black38,
                            ),
                          ),
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        validator: (value) =>
                            value.contains('@') ? null : 'Invalid email',
                        onSaved: (value) {
                          _email = value;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 28),
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 15, right: 7),
                            child: Icon(
                              Icons.person,
                              color: Colors.black38,
                            ),
                          ),
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        validator: (value) =>
                            value.trim().isEmpty ? 'Invalid name' : null,
                        onSaved: (value) {
                          _name = value;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 28),
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 15, right: 7),
                            child: Icon(
                              Icons.person_outline,
                              color: Colors.black38,
                            ),
                          ),
                          labelText: 'username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        validator: (value) =>
                            value.trim().isEmpty ? 'Invalid username' : null,
                        onSaved: (value) {
                          _username = value;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 28),
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 15, right: 7),
                            child: Icon(
                              Icons.vpn_key,
                              color: Colors.black38,
                            ),
                          ),
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                          focusColor: Colors.redAccent,
                        ),
                        obscureText: true,
                        validator: (value) =>
                            value.length < 6 ? 'Invalid password' : null,
                        onSaved: (value) {
                          _password = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  if (_key.currentState.validate()) {
                    final valid = await usernameCheck(_usernameController.text);
                    if (!valid) {
                      setState(() {
                        _isLoading = false;
                      });
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.redAccent,
                          elevation: 0,
                          content: Container(
                            height: 25,
                            child: Center(
                              child: Text('Username already exist.'),
                            ),
                          ),
                        ),
                      );
                    } else {
                      _key.currentState.save();
                      final message = AuthService.signUpUser(context, _name,
                          _username, _email, _password, _scaffoldKey);
                      setState(() {
                        _isLoading = false;
                      });
                      if (message != null) {
                        print(message);
                      }
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFF48B4A),
                          Color(0XFFCA2B7E),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Center(
                      child: Text(
                        'Signup',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      child: Text('Login',
                          style: TextStyle(color: Colors.black45)),
                      onTap: () {
                        Navigator.pushNamed(context, 'login_page');
                      },
                    ),
                    GestureDetector(
                      child: Text('Forgot password?',
                          style: TextStyle(color: Colors.black45)),
                      onTap: () {
                        // TODO: Navigator
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
