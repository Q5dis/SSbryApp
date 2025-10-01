import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F4D4),
      extendBody: true,
      body: Center(
        child: Text('Home Screen'),
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
  }
}