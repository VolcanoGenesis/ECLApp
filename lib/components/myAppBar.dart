import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
      );
  }
}