import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feednet/models/post.dart';
import 'package:feednet/models/user.dart';
import 'package:feednet/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostService with ChangeNotifier {
  final FirebaseFirestore fb = FirebaseFirestore.instance;

  List<Post> _posts = [];
  bool _isLoading = true;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;

  Future<void> loadPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestore.collection('posts').get();

      _posts = querySnapshot.docs.map((doc) {
        return Post(
          id: doc.id,
          title: doc['title'] ?? '',
          description: doc['description'] ?? '',
          firstName: doc['first_name'] ?? '',
          lastName: doc['last_name'] ?? '',
          picture: doc['picture'] ?? '',
        );
      }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error al cargar los posts: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<int> getCommentsCount(String postId) async {
    try {
      QuerySnapshot querySnapshot =
          await fb.collection('posts').doc(postId).collection('comments').get();
      return querySnapshot.docs.length;
    } catch (e) {
      print('Error al obtener el número de comentarios: $e');
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> _loadComments(String postId) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .get();

      return querySnapshot.docs.map((doc) {
        return {
          'text': doc['text'] ?? '',
          'user': doc['user'] ?? '',
        };
      }).toList();
    } catch (e) {
      print('Error al cargar los comentarios: $e');
      return [];
    }
  }

  Future<void> saveReaction(
      BuildContext context, String postId, int reactionValue) async {
    User user =
        await Provider.of<UserService>(context, listen: false).getUserData();
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('reactions')
          .doc(user.username.toString())
          .set({
        'reaction': reactionValue,
      });
    } catch (e) {
      print('Error al guardar la reacción: $e');
    }
  }

  Future<void> changeReaction(BuildContext context, String postId) async {
    User user =
        await Provider.of<UserService>(context, listen: false).getUserData();
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('reactions')
          .doc(user.username.toString())
          .delete();
    } catch (e) {
      print('Error al borrar la reacción: $e');
    }
  }

  Future<void> savePost(
      BuildContext context, String title, String description) async {
    User user =
        await Provider.of<UserService>(context, listen: false).getUserData();
    try {
      await FirebaseFirestore.instance.collection('posts').add({
        'description': description,
        'first_name': user.firstName,
        'last_name': user.lastName,
        'picture': user.picture,
        'title': title,
        'user': user.username,
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Publicación guardada con éxito')),
      );
    } catch (e) {
      print('Error al guardar el post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guarddar la publicación: $e')),
      );
    }
  }
}
