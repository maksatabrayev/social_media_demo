import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_demo/controller/feed_controller.dart';
import 'package:social_media_demo/view/widgets/posts_list.dart';
import 'package:social_media_demo/view/screens/new_post.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  void openAddPostOverlay(FeedController controller) {
    Get.off(() => const NewPost());
  }

  @override
  Widget build(BuildContext context) {
    final FeedController controller = Get.put(FeedController());
    final ScrollController scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        controller.fetchPosts();
      }
    });

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
             // Get.off(() => const AuthScreen());
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.posts.isEmpty && controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return  Column(
            children: [
              Expanded(
                child: PostsList(
                  posts: controller.posts,
                  scrollController: scrollController,
                ),
              ),
              if (controller.isLoading.value)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
            ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openAddPostOverlay(controller),
        tooltip: "Add a post",
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
