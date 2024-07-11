import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_demo/model/post.dart';
import 'package:intl/intl.dart';

class NewPost extends StatefulWidget {
  const NewPost({super.key, required this.addNewPostToList});

  final void Function(Post newPost) addNewPostToList;

  @override
  State<StatefulWidget> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  Uint8List? img;
  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  pickImage(ImageSource imageSource) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: imageSource);

    if (file == null) {
      print("No image selected");
    } else {
      return await file.readAsBytes();
    }
  }

  void selectImage() async {
    Uint8List selectedImg = await pickImage(ImageSource.gallery);
    setState(() {
      img = selectedImg;
    });
  }

  void addPost() async {
    final enteredTitle = _titleController.text.trim();
    final eneteredBody = _bodyController.text.trim();

    if (enteredTitle.isNotEmpty && eneteredBody.isNotEmpty) {
      final formatter = DateFormat('yMMMd').add_Hm();
      Post newPost = Post(
        title: enteredTitle,
        body: eneteredBody,
        date: formatter.format(DateTime.now()),
        image: img == null
            ? Image.asset("assets/default_image.png")
            : Image.memory(img!),
        authorEmail: FirebaseAuth.instance.currentUser!.email!
      );
      widget.addNewPostToList(newPost);
      // Saving to Database:
      savePostToDB(newPost);
      // Back to main Screen
      Navigator.of(context).pop();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Invalid input!"),
          content: const Text("Title and Body can not be empty!"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK")),
          ],
        ),
      );
    }
  }

  Future<String> uploadImageToStorage(
      String childName, Uint8List imageData) async {
    Reference ref = FirebaseStorage.instance.ref().child(childName);
    UploadTask uploadTask = ref.putData(imageData);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> savePostToDB(Post post) async {
    String resp = "Error"; // Default value to return
    try {
      String path =  "postImages/${FirebaseAuth.instance.currentUser!.uid}/${post.id}";  
      String imageUrl =
          img == null ? "NULL" : await uploadImageToStorage(path, img!);
      await FirebaseFirestore.instance.collection("userPosts").add({
        "date": post.date,
        "title": post.title,
        "body": post.body,
        "id": post.id,
        "imageUrl": imageUrl,
        "authorEmail" : post.authorEmail
      });

      resp = "Success";
    } catch (e) {
      resp = e.toString();
    }

    return resp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _titleController,
                maxLength: 50,
                textInputAction: TextInputAction.newline,
                maxLines: null, 
                decoration: const InputDecoration(
                  label: Text("Title"),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: _bodyController,
                maxLength: 150,
                textInputAction: TextInputAction.newline,
                maxLines: null,
                decoration: const InputDecoration(
                  label: Text("Body"),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              img == null
                  ? TextButton(
                      onPressed: selectImage,
                      child: const Row(
                        children: [
                          Text("Attach a file"),
                          Icon(Icons.attach_file_rounded),
                        ],
                      ),
                    )
                  : Image.memory(
                      img!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: addPost,
                    child: const Text("Add Post"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
