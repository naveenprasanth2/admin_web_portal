import 'dart:async';

import 'package:admin_web_portal/sellers/blocked_sellers_screen.dart';
import 'package:admin_web_portal/sellers/verified_sellers_screen.dart';
import 'package:admin_web_portal/users/verified_users_screen.dart';
import 'package:admin_web_portal/widgets/nav_appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../users/blocked_users_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String liveTime = "";
  String liveDate = "";

  String formatCurrentLiveTime(DateTime time) {
    return DateFormat("hh:mm:ss a").format(time);
  }

  String formatCurrentLiveDate(DateTime time) {
    return DateFormat("dd-MMMM-yyyy").format(time);
  }

  getCurrentLiveTimeDate() {
    liveTime = formatCurrentLiveTime(DateTime.now());
    liveDate = formatCurrentLiveDate(DateTime.now());
    setState(() {
      liveDate;
      liveTime;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    Timer.periodic(const Duration(seconds: 1), (timer) {
      getCurrentLiveTimeDate();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: NavAppBar(
        title: "iShop",
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "$liveTime\n$liveDate",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            //users activate and block accounts button ui
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (e) => const VerifiedUserScreen()));
                    },
                    child: Image.asset(
                      "assets/verified_users.png",
                      width: 200,
                    )),
                const SizedBox(
                  width: 200,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (e) => const BlockedUserScreen()));
                    },
                    child: Image.asset(
                      "assets/blocked_users.png",
                      width: 200,
                    )),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (e) => const VerifiedSellerScreen()));
                    },
                    child: Image.asset(
                      "assets/verified_seller.png",
                      width: 200,
                    )),
                const SizedBox(
                  width: 200,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (e) => const BlockedSellerScreen()));
                    },
                    child: Image.asset(
                      "assets/blocked_seller.png",
                      width: 200,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
