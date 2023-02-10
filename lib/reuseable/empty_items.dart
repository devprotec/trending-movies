import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../config/config.dart';

class EmptyWidget extends StatelessWidget {
  final assetPath = 'assets/lottie_animations/empty_items.zip';
  final msg;
  EmptyWidget({this.msg});
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Lottie.asset(assetPath, repeat: false),
        Text(
          msg,
          style: MEDIUM_DISABLED_TEXT,
          textAlign: TextAlign.center,
        )
      ],
    ));
  }
}
