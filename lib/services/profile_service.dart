import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feednet/models/user.dart';
import 'package:feednet/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileService with ChangeNotifier {
  final FirebaseFirestore fb = FirebaseFirestore.instance;
  User user = User();

  Future<DocumentSnapshot> getUserData(BuildContext context) async {
    user = await Provider.of<UserService>(context, listen: false).getUserData();
    return await FirebaseFirestore.instance.collection('users').doc(user.username).get();
  }

  Future<bool> updateStatus(BuildContext context) async {
    user = await Provider.of<UserService>(context).getUserData();
    print('USER => ${user.username}');
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.username)
          .update({'status': 0});
      return true;
    } catch (e) {
      print('Error al actualizar el estado: $e');
      return false;
    }
  }
}
