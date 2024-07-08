import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firebaseAuth = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AuthSceenState();
}

class _AuthSceenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  bool isLogin = false;
  String enteredEmail = " ";
  String enteredPassword = " ";

  void submit() async {
    if (!_form.currentState!.validate()) {
      return;
    }

    _form.currentState!.save();
  try {
    if (isLogin) {
      //Loggin In a user
      final userCrednetials = await firebaseAuth.signInWithEmailAndPassword(email: enteredEmail, password: enteredPassword);
      print(userCrednetials)
       ScaffoldMessenger.of(context).showSnackBar(
         const  SnackBar(
            content: Text('You are logged in'),
          ),
        );
    } else {
      // SigningUp a user
     
        final userCrednetials = await firebaseAuth.createUserWithEmailAndPassword(
            email: enteredEmail, password: enteredPassword);
        print(userCrednetials);
     }
     } on FirebaseAuthException catch (e) {
       ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'Authentication failed'),
          ),
        );
        print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
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
                        key: _form,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: "Email"),
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
                                enteredEmail = newValue!;
                              },
                            ),
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: "Password"),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().length < 6) {
                                  return "Password must be at least 6 characters long";
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                enteredPassword = newValue!;
                              },
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: submit,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer),
                              child: Text(isLogin ? "Log In" : "Sign Up"),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isLogin = !isLogin;
                                });
                              },
                              child: Text(
                                isLogin
                                    ? "Don't have an account? Sign Up"
                                    : "Already have an accout? Log in",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
