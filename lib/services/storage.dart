import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photogram/utilities/constants.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  static Future<String> uploadUserProfileImage(
      String url, File imageFile) async {
    String photoId = Uuid().v4();

    if (url.isNotEmpty) {
      RegExp exp = RegExp(r'userProfile_(.*).jpg');
      photoId = exp.firstMatch(url)[1];
    }

    File image = await compressImage(photoId, imageFile);
    StorageUploadTask uploadTask = storageRef
        .child('images/users/userProfile_$photoId.jpg')
        .putFile(image);
    StorageTaskSnapshot taskSnap = await uploadTask.onComplete;
    String downloadUrl = await taskSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<File> compressImage(String photoId, File image) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    File compessedImage = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      '$path/img_$photoId.jpg',
      quality: 70,
    );
    return compessedImage;
  }

  static Future<List<String>> uploadPost(List<File> images) async {
    List<String> downloadUrls = [];
    for (var i = 0; i < images.length; i++) {
      String photoId = Uuid().v4();
      File compressedImage = await compressImage(photoId, images[i]);
      StorageUploadTask uploadTask = storageRef
          .child('images/posts/post_$photoId.jpg')
          .putFile(compressedImage);
      StorageTaskSnapshot taskSnap = await uploadTask.onComplete;
      downloadUrls.add(await taskSnap.ref.getDownloadURL());
    }

    return downloadUrls;
  }
}
