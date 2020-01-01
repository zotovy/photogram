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

  static void followUser({String currentUserId, String userId}) {
    // Add user to current user's following collection
    followingRef
        .document(currentUserId)
        .collection('userFollowing')
        .document(userId)
        .setData({});
    // Add current user to user's followers collection
    followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .setData({});
  }

  static void unfollowUser({String currentUserId, String userId}) {
    // Remove following user from current user
    followingRef
        .document(userId)
        .collection('userFollowing')
        .document(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    // Remove current user to from user
    followersRef
        .document(currentUserId)
        .collection('userFollowers')
        .document(userId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static Future<bool> isFollowing({String currentUserId, String userId}) async {
    DocumentSnapshot snap = await followersRef
        .document(userId)
        .collection('userFollowers')
        .document(currentUserId)
        .get();

    return snap.exists;
  }

  static Future<int> countFollowers(String userId) async {
    QuerySnapshot snap = await followersRef
        .document(userId)
        .collection('userFollowers')
        .getDocuments();
    return snap.documents.length;
  }

  static Future<int> countFollowing(String userId) async {
    QuerySnapshot snap = await followingRef
        .document(userId)
        .collection('userFollowing')
        .getDocuments();
    return snap.documents.length;
  }
}
