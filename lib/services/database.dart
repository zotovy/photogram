import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photogram/models/activity.dart';
import 'package:photogram/models/comment.dart';
import 'package:photogram/models/post.dart';
import 'package:photogram/models/user.dart';
import 'package:photogram/utilities/constants.dart';
import 'package:uuid/uuid.dart';

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

  static Future<Post> getPostById({String postId, String authorId}) async {
    DocumentSnapshot snap = await postsRef
        .document(authorId)
        .collection('userPosts')
        .document(postId)
        .get();

    if (snap.exists) {
      Post post = Post.fromDoc(snap);
      return post;
    }
    print("Post doesn't exists");
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

    // Add activity
    String id = Uuid().v4();
    activitiesRef
        .document(userId)
        .collection(activitiesTypes.following)
        .document(id)
        .setData(
      {
        'accessoryDataId': '',
        'fromUserId': currentUserId,
        'text': '',
        'timestamp': Timestamp.fromDate(DateTime.now()),
        'toUserId': userId,
        'type': activitiesTypes.following,
      },
    );
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

    // Delete activity
    activitiesRef
        .document(userId)
        .collection(activitiesTypes.following)
        .where('fromUserId', isEqualTo: currentUserId)
        .where('accessoryDataId', isEqualTo: userId)
        .getDocuments()
        .then((snap) {
      if (snap.documents.length != 0) {
        snap.documents[0].reference.delete();
      } else {
        print('No posts found');
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

  static Future<List<User>> getFollowers(String userId) async {
    QuerySnapshot snap = await followersRef
        .document(userId)
        .collection('userFollowers')
        .getDocuments();
    List<User> users = [];
    for (var i = 0; i < snap.documents.length; i++) {
      DocumentSnapshot doc =
          await userRef.document(snap.documents[i].documentID).get();
      User user = User.fromDoc(doc);
      users.add(user);
    }
    return users;
  }

  static Future<List<User>> getFollowing(String userId) async {
    QuerySnapshot snap = await followingRef
        .document(userId)
        .collection('userFollowing')
        .getDocuments();
    List<User> users = [];
    for (var i = 0; i < snap.documents.length; i++) {
      DocumentSnapshot doc =
          await userRef.document(snap.documents[i].documentID).get();
      User user = User.fromDoc(doc);
      users.add(user);
    }
    return users;
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
    if (snapshot.exists) {
      return User.fromDoc(snapshot);
    }
    print("User doen't exists");
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

    // add activity
    String id = Uuid().v4();
    activitiesRef
        .document(post.authorId)
        .collection(activitiesTypes.liking)
        .document(id)
        .setData(
      {
        'accessoryDataId': post.id,
        'fromUserId': userId,
        'text': '',
        'timestamp': Timestamp.fromDate(DateTime.now()),
        'toUserId': post.authorId,
        'type': activitiesTypes.liking,
      },
    );
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

    // Delete activity
    activitiesRef
        .document(post.authorId)
        .collection(activitiesTypes.liking)
        .where('fromUserId', isEqualTo: userId)
        .where('accessoryDataId', isEqualTo: post.id)
        .getDocuments()
        .then((snap) {
      if (snap.documents.length != 0) {
        snap.documents[0].reference.delete();
      } else {
        print('No posts found');
      }
    });
  }

  static Future<int> countComments(String postId) async {
    QuerySnapshot snapshot = await commentsRef
        .document(postId)
        .collection('comments')
        .getDocuments();
    return snapshot.documents.length;
  }

  static Future<List<Comment>> getCommentsByPostId(String postId) async {
    QuerySnapshot snap = await commentsRef
        .document(postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .getDocuments();

    return snap.documents.map((doc) => Comment.fromDoc(doc)).toList();
  }

  static Future<List<User>> getCommentsAuthorByPostId(String postId) async {
    QuerySnapshot snap = await commentsRef
        .document(postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<User> users = [];
    for (var i = 0; i < snap.documents.length; i++) {
      DocumentSnapshot doc =
          await userRef.document(snap.documents[i]['authorId']).get();
      User user = User.fromDoc(doc);
      users.add(user);
    }
    return users;
  }

  static Future<void> createComments(
      {Post post, String userId, Comment comment}) {
    commentsRef
        .document(post.id)
        .collection('comments')
        .document(Uuid().v4())
        .setData(
      {
        'authorId': comment.authorId,
        'postId': comment.postId,
        'text': comment.text,
        'timestamp': comment.timestamp,
      },
    );

    // add activity
    String id = Uuid().v4();
    activitiesRef
        .document(post.id)
        .collection(activitiesTypes.comment)
        .document(id)
        .setData(
      {
        'accessoryDataId': post.id,
        'fromUserId': userId,
        'text': comment.text,
        'timestamp': Timestamp.fromDate(DateTime.now()),
        'toUserId': post.authorId,
        'type': activitiesTypes.comment,
      },
    );
  }

  static Future<void> deleteComment({Post post, String commentId}) {
    commentsRef
        .document(post.id)
        .collection('comments')
        .document(commentId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    // Delete activity
    activitiesRef
        .document(post.authorId)
        .collection(activitiesTypes.comment)
        .where('fromUserId', isEqualTo: post.authorId)
        .where('accessoryDataId', isEqualTo: post.id)
        .getDocuments()
        .then((snap) {
      if (snap.documents.length != 0) {
        snap.documents[0].reference.delete();
      } else {
        print('No posts found');
      }
    });
  }

  static Future<int> countLikes({Post post, String authorId}) async {
    DocumentSnapshot snapshot = await postsRef
        .document(authorId)
        .collection('userPosts')
        .document(post.id)
        .get();
    return snapshot['likeCount'];
  }

  static Future<List<Activity>> getAllActivities(String userId) async {
    List<Activity> activities = [];

    QuerySnapshot likingSnap = await activitiesRef
        .document(userId)
        .collection(activitiesTypes.liking)
        .orderBy('timestamp', descending: true)
        .getDocuments();
    activities +=
        likingSnap.documents.map((doc) => Activity.fromDoc(doc)).toList();

    QuerySnapshot followSnap = await activitiesRef
        .document(userId)
        .collection(activitiesTypes.following)
        .orderBy('timestamp', descending: true)
        .getDocuments();
    activities +=
        followSnap.documents.map((doc) => Activity.fromDoc(doc)).toList();

    QuerySnapshot commentSnap = await activitiesRef
        .document(userId)
        .collection(activitiesTypes.comment)
        .orderBy('timestamp', descending: true)
        .getDocuments();
    activities +=
        commentSnap.documents.map((doc) => Activity.fromDoc(doc)).toList();

    return activities;
  }

  static void addActivity(Activity activity) async {
    if (activity.type == activitiesTypes.liking) {
      addLikeActivity(activity);
    } else if (activity.type == activitiesTypes.following) {
      addFollowActivity(activity);
    } else if (activity.type == activitiesTypes.comment) {
      addCommentActivity(activity);
    }
  }

  static void addCommentActivity(Activity activity) async {
    String id = Uuid().v4();
    activitiesRef
        .document(activity.toUserId)
        .collection(activitiesTypes.comment)
        .document(id)
        .setData(
      {
        'type': activitiesTypes.comment,
        'fromUserId': activity.fromUserId,
        'toUserId': activity.toUserId,
        'text': activity.text,
        'accessoryDataId': activity.accessoryDataId,
        'timestamp': activity.timestamp,
      },
    );
  }

  static void addFollowActivity(Activity activity) async {
    String id = Uuid().v4();
    activitiesRef
        .document(activity.toUserId)
        .collection(activitiesTypes.following)
        .document(id)
        .setData(
      {
        'type': activitiesTypes.following,
        'fromUserId': activity.fromUserId,
        'toUserId': activity.toUserId,
        'text': activity.text,
        'accessoryDataId': activity.accessoryDataId,
        'timestamp': activity.timestamp,
      },
    );
  }

  static void addLikeActivity(Activity activity) async {
    String id = Uuid().v4();
    activitiesRef
        .document(activity.toUserId)
        .collection(activitiesTypes.liking)
        .document(id)
        .setData(
      {
        'type': activitiesTypes.liking,
        'fromUserId': activity.fromUserId,
        'toUserId': activity.toUserId,
        'text': activity.text,
        'accessoryDataId': activity.accessoryDataId,
        'timestamp': activity.timestamp,
      },
    );
  }
}
