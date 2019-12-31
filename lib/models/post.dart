import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final List<String> imagesUrl;
  final String description;
  final List<String> tags;
  final String place;
  final int likeCount;
  final String authorId;
  final Timestamp timestamp;

  Post({
    this.id,
    this.imagesUrl,
    this.description,
    this.tags,
    this.place,
    this.likeCount,
    this.authorId,
    this.timestamp,
  });

  factory Post.fromDoc(DocumentSnapshot doc) {
    return Post(
      id: doc.documentID,
      imagesUrl: doc['imageUrl'],
      description: doc['description'],
      tags: doc['tags'],
      place: doc['place'],
      likeCount: doc['likeCount'],
      authorId: doc['authorId'],
      timestamp: doc['timestamp'],
    );
  }
}
