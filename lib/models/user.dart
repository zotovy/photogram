import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String name;
  final String profileImageUrl;
  final String email;
  final String bio;
  final String bioLink;
  final String profession;
  final String gender;
  final String phone;

  User({
    this.id,
    this.username,
    this.name,
    this.profileImageUrl,
    this.email,
    this.bio,
    this.bioLink,
    this.profession,
    this.gender,
    this.phone,
  });

  factory User.fromDoc(DocumentSnapshot doc) {
    return User(
      id: doc.documentID,
      username: doc['username'],
      name: doc['name'],
      profileImageUrl: doc['profileImageUrl'],
      email: doc['email'],
      bio: doc['bio'] ?? '',
      bioLink: doc['bioLink'] ?? '',
      profession: doc['profession'] ?? '',
      gender: doc['gender'] ?? '',
      phone: doc['phone'] ?? '',
    );
  }
}
