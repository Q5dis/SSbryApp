import 'package:flutter/material.dart';
import 'widgets/bottom_nav.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext){
    return MaterialApp(
      title: 'SSbry',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF27631F)),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: Color(0xFFF5F4D4),
        extendBody: true,
        body: Center(
          child: Text('place content here'),
        ),

        bottomNavigationBar: CustomBottomBar(),
      ),
    );
  }
}