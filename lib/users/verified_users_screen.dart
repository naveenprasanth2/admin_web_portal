import 'package:admin_web_portal/functions/functions.dart';
import 'package:admin_web_portal/homeScreen/home_screen.dart';
import 'package:admin_web_portal/widgets/nav_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifiedUserScreen extends StatefulWidget {
  const VerifiedUserScreen({super.key});

  @override
  State<VerifiedUserScreen> createState() => _VerifiedUserScreenState();
}

class _VerifiedUserScreenState extends State<VerifiedUserScreen> {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  QuerySnapshot? allApprovedUsers;

  showDialogBox(String userDocumentId) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Block this account",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                letterSpacing: 2,
              ),
            ),
            content: const Text(
              "Do you want to block this account?",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16,
                letterSpacing: 2,
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
                  child: const Text("Cancel")),
              ElevatedButton(
                  onPressed: () {
                    Map<String, dynamic> userDataMap = {
                      "status": "not approved"
                    };
                    firebaseFirestore
                        .collection("users")
                        .doc(userDocumentId)
                        .update(userDataMap)
                        .whenComplete(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (e) => const HomeScreen()));
                      showReusableSnackBar(
                          context, "Blocked successfully", Colors.green);
                    });
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
                  child: const Text("Proceed")),
            ],
          );
        });
  }

  getAllVerifiedUsers() {
    firebaseFirestore
        .collection("users")
        .where("status", isEqualTo: "approved")
        .get()
        .then((allVerifiedUsers) {
      setState(() {
        allApprovedUsers = allVerifiedUsers;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getAllVerifiedUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget verifiedUserDesign() {
      if (allApprovedUsers == null) {
        return const Center(
          child: Text(
            "No Approved Users Found",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        );
      } else {
        return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: allApprovedUsers!.docs.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 10,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 180,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              allApprovedUsers!.docs[index].get("photoUrl"),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(allApprovedUsers!.docs[index].get("name")),
                    Text(
                      allApprovedUsers!.docs[index].get("email"),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialogBox(allApprovedUsers!.docs[index].id);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 18.0, bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/block.png", width: 56),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Block Now",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            });
      }
    }

    return Scaffold(
      appBar: NavAppBar(
        title: "Verified Users",
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.50,
          child: verifiedUserDesign(),
        ),
      ),
    );
  }
}
