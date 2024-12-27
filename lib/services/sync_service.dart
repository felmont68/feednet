import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feednet/models/user.dart';
import 'package:feednet/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> initializeDatabase() async {
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, 'feednet.db');  
  return openDatabase(
    path,
    version: 1,
    onCreate: (db, version) {
      db.execute(
        '''
        CREATE TABLE user_profile(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          first_name TEXT,
          last_name TEXT,
          user TEXT,
          password TEXT,
          picture TEXT,
          followers INTEGER, 
          followed INTEGER, 
          publications INTEGER,
          status INTEGER
        )
        '''
      );
    },
  );
}

Stream<Map<String, dynamic>> getUserProfile(String userId, BuildContext context) async* {  
  try {    
    final localData = await getProfileFromLocal();
    yield localData;
  } catch (e) {
    print('No hay datos locales disponibles: $e');
  }
  User user = User();
  user = await Provider.of<UserService>(context, listen: false).getUserData();
  await for (final snapshot in FirebaseFirestore.instance
      .collection(user.username.toString())
      .doc('info')
      .snapshots()) {
    if (snapshot.exists) {
      final userData = snapshot.data() as Map<String, dynamic>;
      await saveProfileLocally(userData, context);
      yield userData;
    }
  }
}

Future<Map<String, dynamic>> getProfileFromLocal() async {
  final db = await openDatabase('feednet.db');
  final List<Map<String, dynamic>> result = await db.query('profile');
  if (result.isNotEmpty) {
    return result.first;
  }
  throw Exception('No hay datos locales');
}


Future<void> saveProfileLocally(Map<String, dynamic> userData, BuildContext context) async {
  final db = await openDatabase('feednet.db', version: 1, onCreate: (db, version) {
    return db.execute(
      'CREATE TABLE profile (id TEXT PRIMARY KEY, first_name TEXT, last_name TEXT, user TEXT, password TEXT, picture TEXT, followers INTEGER, followed INTEGER, publications INTEGER, status INTEGER)',
    );
  });
  await db.insert('UserProfile', userData, conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<void> syncWithFirestore(String userId, BuildContext context) async {
  User user = User();
  user = await Provider.of<UserService>(context, listen: false).getUserData();
  final localData = await getProfileFromLocal();
  final firestoreData = await FirebaseFirestore.instance
      .collection(user.username.toString())
      .doc('info')
      .get();

  if (firestoreData.exists) {
    final remoteData = firestoreData.data() as Map<String, dynamic>;

    if (!isDataEqual(localData, remoteData)) {      
      await FirebaseFirestore.instance.collection(user.username.toString()).doc('info').set(localData);
      await saveProfileLocally(remoteData, context);
    }
  }
}

bool isDataEqual(Map<String, dynamic> localData, Map<String, dynamic> remoteData) {  
  return localData.toString() == remoteData.toString();
}
