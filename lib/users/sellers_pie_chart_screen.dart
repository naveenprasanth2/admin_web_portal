import 'package:admin_web_portal/widgets/nav_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';

class UsersPieChartScreen extends StatefulWidget {
  const UsersPieChartScreen({super.key});

  @override
  State<UsersPieChartScreen> createState() => _UsersPieChartScreenState();
}

class _UsersPieChartScreenState extends State<UsersPieChartScreen> {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  int? totalNumberOfVerifiedUsers = 0;
  int? totalNumberOfBlockedUsers = 0;

  getAllVerifiedUsers() async {
    await firebaseFirestore
        .collection("users")
        .where("status", isEqualTo: "approved")
        .get()
        .then((allVerifiedUsers) {
      setState(() {
        totalNumberOfVerifiedUsers = allVerifiedUsers.docs.length;
      });
    });
  }

  getAllBlockedUsers() async {
    await firebaseFirestore
        .collection("users")
        .where("status", isEqualTo: "not approved")
        .get()
        .then((allBlockedUsers) {
      setState(() {
        totalNumberOfBlockedUsers = allBlockedUsers.docs.length;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getAllBlockedUsers();
    getAllVerifiedUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: NavAppBar(
        title: "Users Pie Chart",
      ),
      body: DChartPie(
        data: [
          {'domain': 'Blocked Users', 'measure': totalNumberOfBlockedUsers},
          {
            'domain': 'Verified Users',
            'measure': totalNumberOfVerifiedUsers
          },
        ],
        fillColor: (pieData, index) {
          switch (pieData['domain']) {
            case "Verified Users":
              return Colors.purpleAccent;
            case "Blocked Users":
              return Colors.pinkAccent;
            default:
              return Colors.pinkAccent;
          }
        },
        labelFontSize: 20,
        animate: false,
        pieLabel: (pieData, index) {
          return "${pieData["domain"]}";
        },
        labelColor: Colors.white,
        strokeWidth: 6,
      ),
    );
  }
}
