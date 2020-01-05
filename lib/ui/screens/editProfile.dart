import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:photogram/models/user.dart';
import 'package:photogram/services/auth.dart';
import 'package:photogram/services/database.dart';
import 'package:photogram/services/storage.dart';

class EditProfilePage extends StatefulWidget {
  static final String id = 'editProfile_page';

  final User user;

  EditProfilePage({this.user});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  GlobalKey<FormState> mainFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> profileInfoFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> contactFormKey = GlobalKey<FormState>();

  String _name;
  String _username;
  String _bioLink;
  String _bio;

  // String _page;
  // String _category;
  // String _contactsOptions;
  // String _profileDisplay;

  String _email;
  String _phone;
  String _gender;

  File _profileImage;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _name = widget.user.name ?? '';
    _username = widget.user.username ?? '';
    _bioLink = widget.user.bioLink ?? '';
    _bio = widget.user.bio ?? '';
    _email = widget.user.email ?? '';
    _phone = widget.user.phone ?? '';
    _gender = widget.user.gender ?? '';
  }

  AppBar _buildAppbar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: GestureDetector(
        child: Icon(Icons.close),
        onTap: () => Navigator.pop(context),
      ),
      title: Text('Edit Profile'),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(10.0),
        child: _isLoading
            ? LinearProgressIndicator(
                backgroundColor: Colors.blue[200],
                valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
              )
            : SizedBox.shrink(),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: GestureDetector(
            child: Icon(
              Icons.done,
              color: Theme.of(context).primaryColor,
              size: 28,
            ),
            onTap: _submit,
          ),
        ),
      ],
    );
  }

  handleImageFromGallery() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: imageFile.path,
          aspectRatioPresets: [CropAspectRatioPreset.square],
          cropStyle: CropStyle.circle,
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.blueAccent,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      if (mounted) {
        setState(() {
          _profileImage = croppedFile ?? imageFile;
        });
      }
    }
  }

  _displayProfileImage() {
    if (_profileImage == null) {
      if (widget.user.profileImageUrl.isEmpty) {
        return AssetImage('assets/images/user_placeholder_image.jpg');
      } else {
        return CachedNetworkImageProvider(widget.user.profileImageUrl);
      }
    } else {
      return FileImage(_profileImage);
    }
  }

  void _submit() async {
    if (mainFormKey.currentState.validate() &&
        profileInfoFormKey.currentState.validate() &&
        contactFormKey.currentState.validate()) {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
      mainFormKey.currentState.save();
      profileInfoFormKey.currentState.save();
      contactFormKey.currentState.save();

      String profileImg = '';

      if (_profileImage == null) {
        profileImg = widget.user.profileImageUrl;
      } else {
        profileImg = await StorageService.uploadUserProfileImage(
          widget.user.profileImageUrl,
          _profileImage,
        );
      }

      User user = User(
        id: widget.user.id,
        username: _username,
        name: _name,
        profileImageUrl: profileImg,
        email: _email,
        bio: _bio,
        bioLink: _bioLink,
        profession: widget.user.profession,
        gender: _gender,
        phone: _phone,
      );

      DatabaseService.updateUser(user);
      Navigator.pop(context);
    }
  }

  Form _mainForm() {
    return Form(
      key: mainFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: handleImageFromGallery,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.black12,
                backgroundImage: _displayProfileImage(),
              ),
            ),
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                initialValue: _name,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                  hoverColor: Colors.blueAccent,
                  prefixIcon: Icon(Icons.person),
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) =>
                    value.trim().length < 1 ? 'This field is required' : null,
                onSaved: (value) => _name = value,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                initialValue: _username,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                  prefixIcon: Icon(Icons.person_outline),
                  labelText: 'username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) =>
                    value.trim().length < 1 ? 'This field is required' : null,
                onSaved: (value) => _username = value,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                initialValue: _bioLink,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                  prefixIcon: Icon(Icons.link),
                  labelText: 'Website',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) => null,
                onSaved: (value) => _bioLink = value,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                initialValue: _bio,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                  prefixIcon: Icon(Icons.library_books),
                  labelText: 'Bio',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) =>
                    value.length > 150 ? 'Please enter valid value' : null,
                onSaved: (value) => _bio = value,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileInfoForm() {
    return Form(
      key: profileInfoFormKey,
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.black12,
          ),
          SizedBox(height: 17),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Row(
              children: <Widget>[
                Text(
                  'Profile Information',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => print('change page'),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Page'),
                  Text(
                    'Connect or Create',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => print('change category'),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Category'),
                  Text('Digital Creator', style: TextStyle(color: Colors.grey))
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => print('change contact options'),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Contact Options'),
                  Text(
                    'Email address, Phone number',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => print('change profile display'),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Profile display'),
                  Text(
                    'Contact hidden',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 7),
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.black12,
          ),
          SizedBox(height: 7),
        ],
      ),
    );
  }

  Form _contactForm() {
    return Form(
      key: contactFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Contact Information',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                initialValue: _email,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) =>
                    value.contains('@') ? null : 'Invalid Email',
                onSaved: (value) => _email = value,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                initialValue: _phone,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                  prefixIcon: Icon(Icons.phone),
                  labelText: 'Phone number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) => null,
                onSaved: (value) => _phone = value,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                initialValue: _gender,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                  prefixIcon: Icon(MdiIcons.genderMaleFemale),
                  labelText: 'Gender',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) => null,
                onSaved: (value) => _gender = value,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _logOutButton() {
    return Container(
      margin: EdgeInsets.only(right: 28, left: 28, bottom: 15),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: Offset(3, 5),
            blurRadius: 5,
            color: Color(0x55F44336),
          )
        ],
        gradient: LinearGradient(
          colors: [Color(0xFFF44336), Color(0xFFC62828)],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            AuthService.logout();
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          },
          child: Center(
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ListView(
        children: <Widget>[
          _mainForm(),
          _profileInfoForm(),
          _contactForm(),
          _logOutButton()
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }
}
