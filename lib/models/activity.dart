import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String id;
  final String type;
  final String fromUserId;
  final String toUserId;
  final String text;
  final String accessoryDataId;
  final Timestamp timestamp;

  Activity({
    this.id,
    this.type,
    this.fromUserId,
    this.toUserId,
    this.text,
    this.accessoryDataId,
    this.timestamp,
  });

  factory Activity.fromDoc(DocumentSnapshot doc) {
    return Activity(
      id: doc.documentID,
      type: doc['type'],
      fromUserId: doc['fromUserId'],
      toUserId: doc['toUserId'],
      text: doc['text'],
      accessoryDataId: doc['accessoryDataId'],
      timestamp: doc['timestamp'],
    );
  }
}

class _ActivitiesTypes {
  final String following = 'following';
  final String liking = 'liking';
  final String likeComment = 'likeComment';
  final String mentioned = 'mentioned';
  final String comment = 'comment';
}

_ActivitiesTypes activitiesTypes = _ActivitiesTypes();
