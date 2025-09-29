import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key}); // <= const constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About Us')),
      body: Center(child: Text('About Rock Dance Company')),
    );
  }
}
