import 'package:flutter/material.dart';
import 'package:test1/pages/aboutusPage.dart';
import 'package:test1/pages/connectPage.dart';
import 'package:test1/pages/homePage.dart';

class NavigationDrawer1 extends StatelessWidget {
  const NavigationDrawer1({super.key});

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(text,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        onTap: onClicked,
      ),
    );
  }

  void selectPage(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomePage()));
        break;
      case 2:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const AboutUs()));
        break;
      case 3:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const ConnectPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("MMNE Lab"),
              accountEmail: Text("mmnelab@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.orange,
                child: Text("M", style: TextStyle(fontSize: 40.0)),
              ),
              decoration: BoxDecoration(
                color: Colors.blue, // Set your desired color here
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  buildMenuItem(
                      text: "Home",
                      icon: Icons.home,
                      onClicked: () => selectPage(context, 0)),
                  buildMenuItem(
                      text: "Connect to Device",
                      icon: Icons.connect_without_contact,
                      onClicked: () => selectPage(context, 3)),
                  buildMenuItem(
                      text: "About Us",
                      icon: Icons.info,
                      onClicked: () => selectPage(context, 2)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
