import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photogram/models/comment.dart';
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
      'place': post.place,
      'likeCount': post.likeCount,
      'authorId': post.authorId,
      'timestamp': post.timestamp,
    });
  }

  static Future<List<Post>> getUserPosts(String userId) async {
    QuerySnapshot snap = await postsRef
        .document(userId)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<Post> posts = snap.documents.map((doc) => Post.fromDoc(doc)).toList();
    return posts;
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

  static Future<List<Post>> getFeddedPost(String userId) async {
    QuerySnapshot snapshot = await feedRef
        .document(userId)
        .collection('userFeed')
        .orderBy('timestamp', descending: true)
        .getDocuments();

    List<Post> posts = [];
    snapshot.documents.forEach((doc) {
      Post post = Post.fromDoc(doc);
      posts.add(post);
    });
    return posts;
  }

  static Future<User> getUserById(String userId) async {
    DocumentSnapshot snapshot = await userRef.document(userId).get();
    return User.fromDoc(snapshot);
  }

  static Future<bool> isFavPost({String userId, String postId}) async {
    DocumentSnapshot snapshot = await favRef
        .document(userId)
        .collection('favPosts')
        .document(postId)
        .get();
    return snapshot.exists;
  }

  static Future<List<Post>> getFavPostByUserId(String userId) async {
    QuerySnapshot snapshot =
        await favRef.document(userId).collection('favPosts').getDocuments();
    List<Post> posts =
        snapshot.documents.map((doc) => Post.fromDoc(doc)).toList();
    return posts;
  }

  static Future<void> createFavPost({String postId, String userId}) {
    favRef.document(userId).collection('favPosts').document(postId).setData({});
  }

  static Future<void> deleteFavPost({String postId, String userId}) {
    favRef
        .document(userId)
        .collection('favPosts')
        .document(postId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static Future<bool> isLikedPost({String userId, String postId}) async {
    DocumentSnapshot snapshot = await likedRef
        .document(postId)
        .collection('likedPosts')
        .document(userId)
        .get();
    return snapshot.exists;
  }

  static Future<void> likePost({Post post, String userId}) async {
    DocumentReference postRef = postsRef
        .document(post.authorId)
        .collection('userPosts')
        .document(post.id);
    postRef.get().then((doc) {
      int likeCount = doc.data['likeCount'];
      postRef.updateData({'likeCount': likeCount + 1});
      likedRef
          .document(post.id)
          .collection('likedPosts')
          .document(userId)
          .setData({});
    });
  }

  static Future<void> unlikePost({Post post, String userId}) async {
    DocumentReference postRef = postsRef
        .document(post.authorId)
        .collection('userPosts')
        .document(post.id);
    postRef.get().then((doc) {
      int likeCount = doc.data['likeCount'];
      postRef.updateData({'likeCount': likeCount - 1});
      likedRef
          .document(post.id)
          .collection('likedPosts')
          .document(userId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    });
  }

  static Future<int> countComments(String postId) async {
    QuerySnapshot snapshot = await commentsRef
        .document(postId)
        .collection('comments')
        .getDocuments();
    return snapshot.documents.length;
  }

  static Future<void> createComments(
      {String postId, String userId, Comment comment}) {
    commentsRef
        .document(postId)
        .collection('comments')
        .document(userId)
        .setData(
      {
        'authorId': comment.authorId,
        'postId': comment.postId,
        'text': comment.text,
        'timestamp': comment.timestamp,
      },
    );
  }

  static Future<void> deleteComment(
      {String postId, String userId, String commentId}) {
    commentsRef
        .document(postId)
        .collection('comments')
        .document(userId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  static void addActivities({String userId, Post post, Comment comment}) async {
    if (comment != null) {
      activitiesRef
          .document(userId)
          .collection('activity')
          .document(post.id)
          .setData(
        {
          'authorId': comment.id,
          'postId': comment.id,
          'text': comment.text,
          'timestamp': comment.timestamp,
        },
      );
    } else {
      activitiesRef
          .document(userId)
          .collection('activity')
          .document(post.id)
          .setData({});
    }
  }

  static Future<int> countLikes({Post post, String authorId}) async {
    DocumentSnapshot snapshot = await postsRef
        .document(authorId)
        .collection('userPosts')
        .document(post.id)
        .get();
    return snapshot['likeCount'];
  }
}
