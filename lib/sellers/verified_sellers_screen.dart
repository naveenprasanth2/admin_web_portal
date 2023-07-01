import 'package:admin_web_portal/functions/functions.dart';
import 'package:admin_web_portal/homeScreen/home_screen.dart';
import 'package:admin_web_portal/widgets/nav_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VerifiedSellerScreen extends StatefulWidget {
  const VerifiedSellerScreen({super.key});

  @override
  State<VerifiedSellerScreen> createState() => _VerifiedSellerScreenState();
}

class _VerifiedSellerScreenState extends State<VerifiedSellerScreen> {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  QuerySnapshot? allApprovedSellers;

  showDialogBox(String sellerDocumentId) {
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
                    Map<String, dynamic> sellerDataMap = {
                      "status": "not approved"
                    };
                    firebaseFirestore
                        .collection("sellers")
                        .doc(sellerDocumentId)
                        .update(sellerDataMap)
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

  getAllVerifiedSellers() {
    firebaseFirestore
        .collection("sellers")
        .where("status", isEqualTo: "approved")
        .get()
        .then((allVerifiedSellers) {
      setState(() {
        allApprovedSellers = allVerifiedSellers;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getAllVerifiedSellers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget verifiedSellerDesign() {
      if (allApprovedSellers == null) {
        return const Center(
          child: Text(
            "No Approved Sellers Found",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        );
      } else {
        return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: allApprovedSellers!.docs.length,
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
                              allApprovedSellers!.docs[index].get("photoUrl"),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(allApprovedSellers!.docs[index].get("name")),
                    Text(
                      allApprovedSellers!.docs[index].get("email"),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialogBox(allApprovedSellers!.docs[index].id);
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
        title: "Verified Sellers",
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.50,
          child: verifiedSellerDesign(),
        ),
      ),
    );
  }
}