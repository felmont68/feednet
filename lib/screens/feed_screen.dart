import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feednet/models/post.dart';
import 'package:feednet/services/theme_app.dart';
import 'package:feednet/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  final bool isUpdated;

  const FeedScreen({super.key, required this.isUpdated});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int likes = 0;
  String selectedReaction = '';
  List<Post> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  @override
  void didUpdateWidget(covariant FeedScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isUpdated != oldWidget.isUpdated && widget.isUpdated) {
      _loadPosts();
    }
  }

  Future<void> _loadPosts() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestore
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .get();

      setState(() {
        posts = querySnapshot.docs.map((doc) {
          return Post(
            id: doc.id,
            title: doc['title'] ?? '',
            description: doc['description'] ?? '',
            firstName: doc['first_name'] ?? '',
            lastName: doc['last_name'] ?? '',
            picture: doc['picture'] ?? '',
          );
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error al cargar los posts: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: null,
        title:
            const Text('Feed', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.wb_sunny
                  : Icons.nightlight_round,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : posts.isEmpty
              ? const Center(child: Text('No hay publicaciones'))
              : ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return PostCard(
                      id: posts[index].id.toString(),
                      title: posts[index].title.toString(),
                      description: posts[index].description.toString(),
                      user:
                          '${posts[index].firstName} ${posts[index].lastName}',
                      avatarUrl: posts[index].picture.toString(),
                      onMoreOptions: () {
                        print('Más opciones!');
                      },
                    );
                  },
                ),
    );
  }
}
