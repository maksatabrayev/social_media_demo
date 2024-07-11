import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final formKey = GlobalKey<FormState>();
  var isLogin = false.obs;
  var enteredEmail = "".obs;
  var enteredPassword = "".obs;

  void submit() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    formKey.currentState!.save();
    try {
      if (isLogin.value) {
        // Logging in a user
        await _firebaseAuth.signInWithEmailAndPassword(
            email: enteredEmail.value, password: enteredPassword.value);
        Get.snackbar(
          'Success',
          'You are logged in',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // Signing up a user
        await _firebaseAuth.createUserWithEmailAndPassword(
            email: enteredEmail.value, password: enteredPassword.value);
        Get.snackbar(
          'Success',
          'Account created',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error',
        e.message ?? 'Authentication failed',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void toggleAuthMode() {
    isLogin.value = !isLogin.value;
  }
}
