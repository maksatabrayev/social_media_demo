import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_demo/view/screens/auth_.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social_media_demo/view/screens/feed.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "FlutterSocialMedia",
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      // Determening the home screen based on whether user is logged in or not
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              return const  FeedScreen();
            } else {
              return const AuthScreen();
            }
          }),
    );
  }
}
