import 'package:flutter/material.dart';
import 'package:xylophone/pages/xylophone_page.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: XylophoneApp(),
    );
  }
}
