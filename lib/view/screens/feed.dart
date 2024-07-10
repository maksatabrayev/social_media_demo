import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_demo/model/post.dart';
import 'package:social_media_demo/view/screens/new_post.dart';
import 'package:social_media_demo/view/widgets/posts_list.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Post> posts = [];

  void addNewPostToList(Post newPost) {
    setState(() {
      posts.add(newPost);
    });
  }

  //   Post(
  //     title: "Me in office",
  //     body: "It was a hard day",
  //     date: "09.07.2024",
  //     image: Image.asset("assets/login-icon-3060.png"),
  //   ),
  //   Post(
  //     title: "A view from my apartment",
  //     body: "Such a beatiful day!!",
  //     date: "09.07.2024",
  //     image: Image.asset("assets/login-icon-3060.png"),
  //   ),
  // ];

  void openAddPostOverlay() {
    // showModalBottomSheet(
    //   useSafeArea: true,
    //   isScrollControlled: true,
    //   context: context,
    //   builder: (ctxt) =>  NewPost(addNewPostToList: addNewPostToList,),
    // );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctxt) => NewPost(
          addNewPostToList: addNewPostToList,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: Text(
          "Feeds",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('userPosts').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData) {
              return const Center(
                child: Text('No posts available'),
              );
            }
            posts = snapshot.data!.docs.reversed.map((doc) {
              return Post(
                title: doc['title'],
                body: doc['body'],
                date: doc['date'],
                image: doc['imageUrl'] == "NULL"
                    ? Image.asset("assets/default_image.png")
                    : Image.network(doc['imageUrl']),
               authorEmail: doc['authorEmail']
              );
            }).toList();
            return PostsList(posts: posts);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddPostOverlay,
        tooltip: "Add a post",
       backgroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
