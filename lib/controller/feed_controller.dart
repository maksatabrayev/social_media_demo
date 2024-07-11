import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_demo/model/post.dart';

class FeedController extends GetxController {
  var posts = <Post>[].obs;
  var isLoading = false.obs;
  DocumentSnapshot? lastDocument;
  final int postLimit = 2;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  void fetchPosts() async {
    if (isLoading.value) return;

    isLoading.value = true;

    Query query = FirebaseFirestore.instance
        .collection('userPosts')
        .orderBy("date", descending: true)
        .limit(postLimit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument!);
    }

    var snapshot = await query.get();

    if (snapshot.docs.isNotEmpty) {
      lastDocument = snapshot.docs.last;

      posts.addAll(snapshot.docs.map((doc) {
        return Post(
          title: doc['title'],
          body: doc['body'],
          date: doc['date'],
          image: doc['imageUrl'] == "NULL"
              ? Image.asset("assets/default_image.png")
              : Image.network(doc['imageUrl']),
          authorEmail: doc['authorEmail'],
        );
      }).toList());
    }

    isLoading.value = false;
  }


    void addNewPostToList(Post newPost) {
    posts.add(newPost);
  }
}

