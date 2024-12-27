import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feednet/models/user.dart';
import 'package:feednet/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showCommentSheet(BuildContext context, String postId, String currentUser) {
  final TextEditingController commentController = TextEditingController();
  String action = 'save';
  String docId = '';

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20.0),
      ),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Comentarios',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(postId)
                    .collection('comments')
                    .orderBy('timestamp')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No hay comentarios aún.'));
                  }

                  final comments = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment =
                          comments[index].data() as Map<String, dynamic>;
                      final commentText = comment['comment'] ?? '';
                      final userName =
                          '${comment['first_name']} ${comment['last_name']}' ??
                              'Usuario Anónimo';
                      final commentUserName = comment['user'];
                      docId = comments[index].id;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(comment['picture']),
                          radius: 20.0,
                        ),
                        title: Text(
                          userName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(commentText),
                        trailing: commentUserName == currentUser
                            ? PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    commentController.text = commentText;
                                    action = 'edit';
                                  } else if (value == 'delete') {
                                    await FirebaseFirestore.instance
                                        .collection('posts')
                                        .doc(postId)
                                        .collection('comments')
                                        .doc(comments[index].id)
                                        .delete();
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return [
                                    const PopupMenuItem<String>(
                                      value: 'edit',
                                      child: Text('Editar'),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Text('Eliminar'),
                                    ),
                                  ];
                                },
                              )
                            : null,
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        hintText: 'Agregar comentario...',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color ??
                            Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: () async {
                      if (commentController.text.trim().isNotEmpty && action == 'save') {
                        User user = User();
                        user = await Provider.of<UserService>(context,
                                listen: false)
                            .getUserData();
                        FirebaseFirestore.instance
                            .collection('posts')
                            .doc(postId)
                            .collection('comments')
                            .add({
                          'comment': commentController.text.trim(),
                          'first_name': user.firstName,
                          'last_name': user.lastName,
                          'picture': user.picture,
                          'user': user.username,
                          'timestamp': FieldValue.serverTimestamp(),
                        }).then((_) {
                          commentController.clear();
                        });
                      } else if (commentController.text.trim().isNotEmpty && action == 'edit') {
                        await FirebaseFirestore.instance
                            .collection('posts')
                            .doc(postId)
                            .collection('comments')
                            .doc(docId)
                            .update({
                          'comment': commentController.text.trim(),
                        });
                        commentController.clear();
                        action = 'save';
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
