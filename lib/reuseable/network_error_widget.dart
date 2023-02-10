import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class NetworkErrorWidget extends StatelessWidget {
  final assetPath = 'assets/lottie_animations/network_error.zip';
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child:
          Lottie.asset(
            assetPath,
            repeat: false
          ),          
    );
  }
}