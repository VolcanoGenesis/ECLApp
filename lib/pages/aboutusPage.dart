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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add padding for better layout
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/EmbeddedImage.png', // Replace with your image asset path
                width: 200, // Set width or height as desired
                height: 150,
                fit: BoxFit.cover, // Adjust to control image fitting
              ),
              const SizedBox(height: 20), // Add spacing between image and text
              const Text(
                'MEMS, Microfluidics and Nanoelectronics Lab is a collaborative effort across the departments at BITS-Pilani, Hyderabad Campus. The lab is spread across 2500 sqft. It has various fabrication, characterization and testing facilities. The lab majorly focuses on the development of miniaturized sensing/monitoring devices for various Energy, Biomedical and Biochemical applications.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
