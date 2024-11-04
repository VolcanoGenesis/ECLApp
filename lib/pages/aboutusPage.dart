import 'package:flutter/material.dart';
import 'package:test1/components/myDrawer.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<StatefulWidget> createState() => _AboutUs();
}

class _AboutUs extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawer1(),
      appBar: AppBar(
        title: const Text("About Us"),
      ),
      body: const Center(child: Text("TODO")),
    );
  }
}
