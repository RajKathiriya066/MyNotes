import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: "Enter your email here"),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration:
                const InputDecoration(hintText: "Enter your password here"),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              if (email.trim().isNotEmpty && password.trim().isNotEmpty) {
                try {
                  final userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email, password: password);
                } on FirebaseAuthException catch (e) {
                  AlertDialog d;
                  if (e.code == "email-already-in-use") {
                    d = const AlertDialog(
                      title: Text("error"),
                      content: Text("Email already in use"),
                    );
                  } else if (e.code == "weak-password") {
                    d = const AlertDialog(
                      title: Text("error"),
                      content: Text("Weak password"),
                    );
                  } else if (e.code == "invalid-email") {
                    d = const AlertDialog(
                      title: Text("error"),
                      content: Text("Invalid email"),
                    );
                  } else {
                    d = const AlertDialog(
                      title: Text("error"),
                      content: Text("UNKNOWN ERROR"),
                    );
                  }
                  showDialog(
                      context: context, builder: (BuildContext context) => d);
                } catch (e) {
                  debugPrint(e.runtimeType.toString());
                  debugPrint(e.toString());
                }
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("/login/", (route) => false);
              },
              child: const Text("Login here")),
        ],
      ),
    );
  }
}
