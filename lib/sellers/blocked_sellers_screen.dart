import 'package:admin_web_portal/functions/functions.dart';
import 'package:admin_web_portal/homeScreen/home_screen.dart';
import 'package:admin_web_portal/widgets/nav_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BlockedSellerScreen extends StatefulWidget {
  const BlockedSellerScreen({super.key});

  @override
  State<BlockedSellerScreen> createState() => _BlockedSellerScreenState();
}

class _BlockedSellerScreenState extends State<BlockedSellerScreen> {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  QuerySnapshot? allBlockedSellers;

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
              "Do you want to activate this account?",
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
                      "status": "approved"
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
                          context, "Activated successfully", Colors.green);
                    });
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
                  child: const Text("Proceed")),
            ],
          );
        });
  }

  getAllBlockedSellers() {
    firebaseFirestore
        .collection("sellers")
        .where("status", isEqualTo: "not approved")
        .get()
        .then((allVerifiedUsers) {
      setState(() {
        allBlockedSellers = allVerifiedUsers;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initStater
    getAllBlockedSellers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget verifiedSellerDesign() {
      if (allBlockedSellers == null) {
        return const Center(
          child: Text(
            "No Blocked Users Found",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        );
      } else {
        return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: allBlockedSellers!.docs.length,
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
                              allBlockedSellers!.docs[index].get("photoUrl"),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(allBlockedSellers!.docs[index].get("name")),
                    Text(
                      allBlockedSellers!.docs[index].get("email"),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialogBox(allBlockedSellers!.docs[index].id);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 18.0, bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/activate.png", width: 56),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Activate Now",
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
        title: "Blocked Users",
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
