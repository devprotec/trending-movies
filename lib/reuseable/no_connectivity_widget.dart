import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoConnectivityWidget extends StatelessWidget {
  
  
  final assetPath = 'assets/lottie_animations/no_internet.zip';
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child:  Lottie.asset(
          assetPath,
        ),
    );
  }
}