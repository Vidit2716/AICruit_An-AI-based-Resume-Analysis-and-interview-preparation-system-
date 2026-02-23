import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loader extends StatelessWidget {
  final double loaderSize;

  const Loader({
    super.key,
    this.loaderSize = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: loaderSize,
        child: Lottie.asset('assets/lottie/Animation - 1722849502295.json'),
      ),
    );
  }
}
