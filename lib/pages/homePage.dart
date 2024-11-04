import 'package:flutter/material.dart';
import 'package:test1/components/myDrawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawer1(),
      appBar: AppBar(
        title: const Text('ECLSTAT 3.0'),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'BPHC',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
      body: Center(
        child: Image.asset(
          'Assets/EmbeddedImage.png', // Add your image in assets folder
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
