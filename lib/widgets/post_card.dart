import 'package:feednet/models/user.dart';
import 'package:feednet/services/post_service.dart';
import 'package:feednet/services/user_service.dart';
import 'package:feednet/widgets/comment_box.dart';
import 'package:feednet/widgets/reactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:provider/provider.dart';

class PostCard extends StatelessWidget {
  String id;
  String title;
  String description;
  String user;
  String avatarUrl;
  VoidCallback onMoreOptions;

  PostCard({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.user,
    required this.avatarUrl,
    required this.onMoreOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(avatarUrl),
                      radius: 20.0,
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      user,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: onMoreOptions,
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              description,
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ReactionButton<String>(
                      itemSize: const Size.square(30),
                      onReactionChanged: (Reaction<String>? reaction) async {
                        if (reaction?.value?.toString() == null) {
                          await Provider.of<PostService>(context, listen: false)
                              .changeReaction(context, id);
                        } else {
                          await Provider.of<PostService>(context, listen: false)
                              .saveReaction(context, id,
                                  int.parse(reaction!.value!.toString()));
                        }
                      },
                      reactions: reactions,
                      placeholder: const Reaction<String>(
                        value: null,
                        icon: Icon(
                          Icons.thumb_up,
                          color: Colors.grey,
                          size: 22,
                        ),
                      ),
                      selectedReaction: reactions.first,
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.message),
                      onPressed: () async {
                        User user = User();
                        user = await Provider.of<UserService>(context,
                                listen: false)
                            .getUserData();
                        showCommentSheet(context, id, user.username.toString());
                      },
                    ),
                    FutureBuilder<int>(
                      future: Provider.of<PostService>(context)
                          .getCommentsCount(id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          print('Error: ${snapshot.error}');
                          return const Text('0');
                        } else if (snapshot.hasData) {
                          return Text('${snapshot.data}');
                        } else {
                          print('No se pudo obtener el número de comentarios');
                          return const Text('0');
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/*import 'package:feednet/services/post_service.dart';
import 'package:feednet/widgets/reactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final String id;
  final String title;
  final String description;
  final String user;
  final String avatarUrl;
  //final int userReaction;
  final VoidCallback onMoreOptions;

  const PostCard({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.user,
    required this.avatarUrl,
    //required this.userReaction,
    required this.onMoreOptions,
  });

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int selectedReaction = -1;

  @override
  void initState() {
    super.initState();    
    selectedReaction = widget.userReaction;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.avatarUrl),
                      radius: 20.0,
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      widget.user,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: widget.onMoreOptions,
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.description,
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ReactionButton<int>(
                      itemSize: const Size.square(30),
                      onReactionChanged: (Reaction<int>? reaction) async {                        
                        if (reaction != null) {
                          setState(() {
                            selectedReaction = reaction.value!;
                          });
                          if (reaction.value?.toString() == null) {
                          await Provider.of<PostService>(context, listen: false)
                              .changeReaction(context, widget.id);
                        } else {
                          await Provider.of<PostService>(context, listen: false)
                              .saveReaction(context, widget.id,
                                  int.parse(reaction.value!.toString()));
                        }
                        }
                      },
                      reactions: reactions,
                      placeholder: const Reaction<int>(
                        value: -1,
                        icon: Icon(
                          Icons.thumb_up,
                          color: Colors.grey,
                          size: 22,
                        ),
                      ),
                      selectedReaction: reactions.firstWhere(
                        (reaction) => reaction.value == selectedReaction,
                        orElse: () => reactions.first,
                      ),                      
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}*/