import 'package:flutter/material.dart';

// Shown when the app first starts up, gives app time to initialize and load any saved settings
class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      const Scaffold(backgroundColor: Colors.grey, body: Center(child: FlutterLogo(size: 400)));
}
