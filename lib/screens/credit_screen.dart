import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreditScreen extends StatelessWidget {
  const CreditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F4D4),
      extendBody: true,
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('크레딧 스크린 Screen?!'),
            SvgPicture.asset('../images/icon.svg',width: 100,height: 100,),
            Text('what the helly\n test테스팅'),
          ],
    )
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
  }
}