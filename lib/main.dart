import 'package:admin_web_portal/authentication/login_screen.dart';
import 'package:admin_web_portal/homeScreen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: const FirebaseOptions(
      apiKey: "AIzaSyAnRH77UbtdjUJdZtkIjOUjbwyvLSOGklM",     // take these values from your index.html.
      appId: "1:1097011694914:web:9b6204a49ab1b6424cccdb",        //code which you pasted from firebase.
      messagingSenderId: "1097011694914",
      projectId: "clone-c3dbe",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Web Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: FirebaseAuth.instance.currentUser !=null ? const HomeScreen(): const LoginScreen(),
    );
  }
}

