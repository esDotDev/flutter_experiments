import 'package:flutter/cupertino.dart';
import 'package:random_color/random_color.dart';

class RandomlyColoredTappableBox extends StatelessWidget {
  const RandomlyColoredTappableBox({Key? key, required this.onTap, required this.content}) : super(key: key);
  final VoidCallback onTap;
  final String content;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: double.infinity,
        color: RandomColor().randomColor(),
        child: Text(content),
      ),
    );
    ;
  }
}
