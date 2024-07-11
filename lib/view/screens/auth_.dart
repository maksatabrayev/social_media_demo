import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_demo/controller/auth_controller.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.put(AuthController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      // appBar: AppBar(
      //   title: Text(
      //     "Auth Screen",
      //     style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      //   ),
      //   backgroundColor: Theme.of(context).colorScheme.primary,
      // ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Theme.of(context).colorScheme.primary,
                margin: const EdgeInsets.all(20),
                width: 200,
                child: Image.asset("assets/login-icon-3060.png"),
              ),
              Card(
                margin: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(labelText: "Email"),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              controller.enteredEmail.value = newValue!;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(labelText: "Password"),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return "Password must be at least 6 characters long";
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              controller.enteredPassword.value = newValue!;
                            },
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: controller.submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            ),
                            child: Obx(() => Text(controller.isLogin.value ? "Log In" : "Sign Up")),
                          ),
                          TextButton(
                            onPressed: controller.toggleAuthMode,
                            child: Obx(() => Text(controller.isLogin.value
                                ? "Don't have an account? Sign Up"
                                : "Already have an account? Log in")),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
