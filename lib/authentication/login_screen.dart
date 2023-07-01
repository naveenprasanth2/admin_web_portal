import 'package:admin_web_portal/functions/functions.dart';
import 'package:admin_web_portal/homeScreen/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = "";
  String password = "";
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  allowAdminToLogin() async {
    if (email.isEmpty || password.isEmpty) {
      showReusableSnackBar(
          context, "Checking Credentials..., Please wait...", Colors.green);
    } else {
      //allow admin to login
      User? currentAdmin;
      await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        currentAdmin = value.user;
      }).catchError((error) {
        showReusableSnackBar(context, "error occurred $error", Colors.red);
      });
      //check admin database if record exists
      firebaseFirestore
          .collection("admins")
          .doc(currentAdmin!.uid)
          .get()
          .then((snapshot) {
        if (snapshot.exists) {
          Navigator.push(
              context, MaterialPageRoute(builder: (e) => const HomeScreen()));
        } else {
          showReusableSnackBar(context, "No records found...", Colors.red);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/admin.png"),
                  TextField(
                    onChanged: (value) {
                      email = value;
                    },
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.purpleAccent, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white54, width: 2),
                        ),
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.grey),
                        icon: Icon(
                          Icons.email,
                          color: Colors.deepPurpleAccent,
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    onChanged: (value) {
                      password = value;
                    },
                    obscureText: true,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.purpleAccent, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white54, width: 2),
                        ),
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.grey),
                        icon: Icon(
                          Icons.email,
                          color: Colors.deepPurpleAccent,
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                        onPressed: () {
                          showReusableSnackBar(
                              context,
                              "Checking Credentials... Please wait...",
                              Colors.green);

                          allowAdminToLogin();
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 100, vertical: 20),
                            backgroundColor: Colors.deepPurpleAccent),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
