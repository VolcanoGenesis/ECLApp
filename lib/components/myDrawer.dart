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
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onClicked,
    );
  }

  void selectPage(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HomePage(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const AboutUs(),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ConnectPage(),
        ));
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
              children: <Widget>[
                const UserAccountsDrawerHeader(
                  accountName: Text("User"),
                  accountEmail: Text("user@gmail.com"),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Text(
                      "U",
                      style: TextStyle(fontSize: 40.0),
                    ),
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
                          text: "About Us",
                          icon: Icons.contacts,
                          onClicked: () => selectPage(context, 2)),
                      buildMenuItem(
                          text: "Connect to Device",
                          icon: Icons.contacts,
                          onClicked: () => selectPage(context, 3)),
                    ],
                  ),
                ),
              ],
            )));
  }
}
