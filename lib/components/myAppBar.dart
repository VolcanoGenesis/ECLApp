import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'ECLSTAT 3.0',
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white), // Enhanced title styling
      ),
      centerTitle: true,
      backgroundColor: Colors.blue, // Custom background color
      elevation: 4.0, // Added elevation for depth
      leading: IconButton(
        icon: const Icon(Icons.menu,
            color: Colors.white), // Leading icon for navigation
        onPressed: () {
          // Handle menu action (e.g., open drawer)
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings,
              color: Colors.white), // Action icon for settings
          onPressed: () {
            // Handle settings action
          },
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'BPHC',
            style: TextStyle(
                fontSize: 12,
                color: Colors.white), // Improved text styling and contrast
          ),
        ),
      ],
    );
  }
}
