import 'package:admin_web_portal/homeScreen/home_screen.dart';
import 'package:flutter/material.dart';

class NavAppBar extends StatefulWidget implements PreferredSizeWidget {
  PreferredSizeWidget? preferredSizeWidget;
  String? title;

  NavAppBar({super.key, this.preferredSizeWidget, this.title});

  @override
  State<NavAppBar> createState() => _NavAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => preferredSizeWidget == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}

class _NavAppBarState extends State<NavAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (e)=> const HomeScreen()));
        },
        child: const Text(
          "iShop",
          style: TextStyle(
            fontSize: 26,
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      centerTitle: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.pinkAccent, Colors.deepPurpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.topRight)),
      ),
      actions: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (e)=> const HomeScreen()));
                  },
                  child: const Text(
                    "Home",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )),
            ),
            const Text(
              "|",
              style: TextStyle(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Sellers PieChart",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )),
            ),
            const Text(
              "|",
              style: TextStyle(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Users PieChart",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )),
            ),
            const Text(
              "|",
              style: TextStyle(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )),
            ),
          ],
        ),
      ],
    );
  }
}