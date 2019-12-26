import 'package:flutter/material.dart';
import 'package:photogram/services/auth.dart';

class LoginPage extends StatefulWidget {
  static final String id = 'login_page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              Icons.vpn_key,
                              color: Colors.black38,
                            ),
                          ),
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
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
                onTap: () {
                  if (_key.currentState.validate()) {
                    _key.currentState.save();
                    AuthService.login(_email, _password, _scaffoldKey);
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
                          Color(0xFFCA2B7E),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Center(
                      child: Text(
                        'Login',
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
                      child: Text('Signup',
                          style: TextStyle(color: Colors.black45)),
                      onTap: () {
                        Navigator.pushNamed(context, 'signup_page');
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
