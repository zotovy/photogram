import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photogram/models/post.dart';
import 'package:photogram/models/userData.dart';
import 'package:photogram/services/database.dart';
import 'package:photogram/services/storage.dart';
import 'package:provider/provider.dart';

class CreatePostPage extends StatefulWidget {
  static final String id = 'createPost_page';

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  List<File> _images;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _description;
  List<String> _tags = [];
  String _place;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _images = [];
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Camera'),
                  onTap: () {
                    handleImageFromGallery(ImageSource.camera);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.image),
                  title: new Text('Gallery'),
                  onTap: () {
                    handleImageFromGallery(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  handleImageFromGallery(ImageSource sourse) async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: imageFile.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.original,
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.grey[700],
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));

      if (croppedFile != null) {
        setState(() {
          _images.add(croppedFile ?? imageFile);
        });
      }
    }
  }

  Widget _buildPhotoAddRow() {
    return Container(
      width: double.infinity,
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _images.length < 5 ? _images.length + 1 : _images.length,
        itemBuilder: (BuildContext context, int i) {
          return i == _images.length
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      splashColor: Colors.grey[100],
                      icon: Icon(Icons.add),
                      onPressed: () => _settingModalBottomSheet(context),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 35,
                          height: 35,
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _images.removeAt(i);
                              });
                            },
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(1, 3),
                                blurRadius: 3,
                                color: Colors.black45,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[200],
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          blurRadius: 5,
                          color: Colors.grey[300],
                        ),
                      ],
                      image: DecorationImage(
                        image: FileImage(_images[i]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }

  _submit() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      if (_formKey.currentState.validate()) {
        if (_images.length == 0) {
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.redAccent[200],
              elevation: 0,
              content: Container(
                height: 25,
                child: Center(
                  child: Text('Please, select at least 1 photo'),
                ),
              ),
            ),
          );
        } else {
          _formKey.currentState.save();

          // Add to DB
          List<String> imgUrls = await StorageService.uploadPost(_images);

          Post post = Post(
            imagesUrl: imgUrls,
            description: _description,
            tags: _tags,
            place: _place,
            likeCount: 0,
            authorId:
                Provider.of<UserData>(context, listen: false).currentUserId,
            timestamp: Timestamp.fromDate(DateTime.now()),
          );

          DatabaseService.uploadPost(post);
          Navigator.pop(context);
        }
      }
    }
  }

  Widget _buildBody() {
    return Form(
      key: _formKey,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 25, bottom: 7),
              child: Text(
                'Description:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 10,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                  hoverColor: Colors.blueAccent,
                  hintText: 'Enter Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) => value.trim().length > 1000
                    ? 'Too long. Max is 1000 charachters'
                    : null,
                onSaved: (value) => _description = value,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 7),
              child: Text(
                'Tags:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                  hoverColor: Colors.blueAccent,
                  hintText: 'Enter tags through the gap',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) => value.split(' ').length > 30
                    ? 'Too many tags. Max is 30'
                    : null,
                onSaved: (value) => _tags = value.split(' '),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 7),
              child: Text(
                'Place:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                  hoverColor: Colors.blueAccent,
                  hintText: 'Enter a place',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) =>
                    value.length > 100 ? 'Too long. Max is 100' : null,
                onSaved: (value) => _place = value,
              ),
            ),
            SizedBox(height: 15),
            GestureDetector(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [Color(0xFFf48b4a), Color(0xFFca2b7e)],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(1, 3),
                      blurRadius: 3,
                      color: Colors.black12,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Create a post',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              onTap: _submit,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => _isLoading ? null : Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text('Create new post'),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10),
                child: ListView(
                  children: <Widget>[
                    _buildPhotoAddRow(),
                    _buildBody(),
                  ],
                ),
              ),
      ),
    );
  }
}
