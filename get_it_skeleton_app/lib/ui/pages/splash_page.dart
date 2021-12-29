import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Material(
        child: Center(child: CircularProgressIndicator()),
      );
}
