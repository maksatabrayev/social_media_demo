import 'package:flutter/material.dart';
import 'package:social_media_demo/model/post.dart';
import 'package:social_media_demo/view/widgets/post_item.dart';

class PostsList extends StatelessWidget {
  final List<Post> posts;
  final ScrollController scrollController;

  const PostsList({
    super.key, 
    required this.posts,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: posts.length,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.all(8),
        child: PostItem(
          post: posts[index],
        ),
      ),
    );
  }
}
