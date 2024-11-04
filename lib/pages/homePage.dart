import 'package:flutter/material.dart';
import 'package:test1/components/myDrawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('ECLSTAT 3.0'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
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
