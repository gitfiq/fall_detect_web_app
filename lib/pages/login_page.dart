// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fall_detect_web_app/data/user_id.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void dismissLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> _authenticateAndInitialize(
      String deviceId, UserId userInput) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "123456abcdef@gmail.com",
        password: "fedcba654321",
      );

      if (userCredential.user != null) {
        // Dismiss loading dialog
        dismissLoadingDialog(context);
        Navigator.pushReplacementNamed(context, '/homepage',
            arguments: userInput);
      }
    } catch (e) {
      print("Authentication failed: $e");
      print(
          "Authentication Failed. Unable to authenticate with the default email and password.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/Background.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20.0),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.60,
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Image.asset('images/Logo.jpg'),
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: TextFormField(
                              controller: _textController,
                              decoration: const InputDecoration(
                                labelText: "Enter a the device ID",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a value';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                String deviceId = _textController.text;
                                UserId userInput = UserId(deviceId);

                                // Show loading dialog
                                _showLoadingDialog(context);

                                try {
                                  // Retrieve the document from Firestore
                                  DocumentSnapshot documentSnapshot =
                                      await FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(
                                              deviceId) // Use the deviceId as the document ID
                                          .get();

                                  // Check if the document exists
                                  if (documentSnapshot.exists) {
                                    await _authenticateAndInitialize(
                                        deviceId, userInput);
                                  } else {
                                    // Dismiss loading dialog
                                    dismissLoadingDialog(context);

                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.grey[800],
                                          title: const Text(
                                            "Device ID Not Found",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          content: Text(
                                            "The device ID '$deviceId' does not exist.",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                "OK",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                } catch (e) {
                                  // Handle any errors
                                  print("Error retrieving document: $e");
                                  // Dismiss loading dialog
                                  dismissLoadingDialog(context);
                                }
                              } else {
                                // Form is not valid, show snackbar to enter a device ID
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please enter a device ID."),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.35, 50),
                            ),
                            child: const Text(
                              'Start Monitoring',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
