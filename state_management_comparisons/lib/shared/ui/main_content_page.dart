import 'package:flutter/material.dart';

class MainContentPage extends StatelessWidget {
  final Widget leftSide;
  final Widget rightSide;
  final String title;

  const MainContentPage(this.title, {Key? key, required this.leftSide, required this.rightSide}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            Expanded(child: leftSide),
            Expanded(child: rightSide),
          ],
        ),
        const Text('GET IT', style: TextStyle(fontSize: 24)),
      ],
    );
  }
}
