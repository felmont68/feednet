import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String? id;
  String? title;
  String? description;
  String? firstName;
  String? lastName;
  String? picture;
  Map<String, int>? reactions;

  Post({
    this.id,
    this.title,
    this.description,
    this.firstName,
    this.lastName,
    this.picture,
    this.reactions,
  });

   Post copyWith({
    String? id,
    String? title,
    String? description,
    String? firstName,
    String? lastName,
    String? picture
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      picture: picture ?? this.picture
    );
  }

  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Post(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      picture: data['picture'] ?? '',
      reactions: Map<String, int>.from(data['reactions'] ?? {}),
    );
  }
}
