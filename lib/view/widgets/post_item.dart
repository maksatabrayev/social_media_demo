import 'package:flutter/material.dart';
import 'package:social_media_demo/model/post.dart';
import 'package:social_media_demo/view/screens/post_details.dart';

class PostItem extends StatelessWidget {
  const PostItem({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    // final String authEmail = post.authorEmail;
    // final String date = post.date;
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctxt) => PostDetails(post: post),
            ),
          );
        },
        splashColor: Theme.of(context).colorScheme.onPrimary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.authorEmail,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 8),
              Text(post.date),
              const SizedBox(height: 8),
              Container(child: post.image),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(post.body)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
