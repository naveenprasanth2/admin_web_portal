import 'package:admin_web_portal/widgets/nav_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';

class SellersPieChartScreen extends StatefulWidget {
  const SellersPieChartScreen({super.key});

  @override
  State<SellersPieChartScreen> createState() => _SellersPieChartScreenState();
}

class _SellersPieChartScreenState extends State<SellersPieChartScreen> {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  int? totalNumberOfVerifiedSellers = 0;
  int? totalNumberOfBlockedSellers = 0;

  getAllVerifiedSellers() async {
    await firebaseFirestore
        .collection("sellers")
        .where("status", isEqualTo: "approved")
        .get()
        .then((allVerifiedSellers) {
      setState(() {
        totalNumberOfVerifiedSellers = allVerifiedSellers.docs.length;
      });
    });
  }

  getAllBlockedSellers() async {
    await firebaseFirestore
        .collection("sellers")
        .where("status", isEqualTo: "not approved")
        .get()
        .then((allBlockedSellers) {
      setState(() {
        totalNumberOfBlockedSellers = allBlockedSellers.docs.length;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getAllBlockedSellers();
    getAllVerifiedSellers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: NavAppBar(
        title: "Sellers Pie Chart",
      ),
      body: DChartPie(
        data: [
          {'domain': 'Blocked Sellers', 'measure': totalNumberOfBlockedSellers},
          {
            'domain': 'Verified Sellers',
            'measure': totalNumberOfVerifiedSellers
          },
        ],
        fillColor: (pieData, index) {
          switch (pieData['domain']) {
            case "Verified Sellers":
              return Colors.purpleAccent;
            case "Blocked Sellers":
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
