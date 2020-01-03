import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String authorId;
  final String postId;
  final String text;
  final Timestamp timestamp;

  Comment({
    this.id,
    this.authorId,
    this.postId,
    this.text,
    this.timestamp,
  });

  factory Comment.fromDoc(DocumentSnapshot doc) {
    return Comment(
      id: doc.documentID,
      authorId: doc['authorId'],
      postId: doc['postId'],
      text: doc['text'],
      timestamp: doc['timestamp'],
    );
  }
}
