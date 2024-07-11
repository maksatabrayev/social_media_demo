import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Post{
  Post({
    required this.title,
    required this.body,
    required this.date,
    required this.image,
    required this.authorEmail
  }) : id = uuid.v4();

  final Image image;
  final String date;
  final String title;
  final String body;
  final String id;
  final String authorEmail;
}