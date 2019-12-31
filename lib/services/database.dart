import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photogram/models/post.dart';
import 'package:photogram/models/user.dart';
import 'package:photogram/utilities/constants.dart';

class DatabaseService {
  static void updateUser(User user) {
    userRef.document(user.id).updateData({
      'name': user.name,
      'username': user.username,
      'profileImageUrl': user.profileImageUrl,
      'bio': user.bio,
      'bioLink': user.bioLink,
      'email': user.email,
      'profession': user.profession,
      'gender': user.gender,
      'phone': user.phone,
    });
  }

  static Future<QuerySnapshot> searchUsers(String name) {
    Future<QuerySnapshot> users =
        userRef.where('name', isGreaterThanOrEqualTo: name).getDocuments();
    return users;
  }

  static void uploadPost(Post post) {
    postsRef.document(post.authorId).collection('userPosts').add({
      'imagesUrl': post.imagesUrl,
      'description': post.description,
      'tags': post.tags,
      'place': post.tags,
      'likeCount': post.likeCount,
      'authorId': post.authorId,
      'timestamp': post.timestamp,
    });
  }
}
