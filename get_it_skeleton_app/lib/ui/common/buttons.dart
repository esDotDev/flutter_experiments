import 'package:flutter/material.dart';

class AppBtn extends StatelessWidget {
  const AppBtn({Key? key, required this.label, required this.onTap}) : super(key: key);
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 20, horizontal: 50)),
        ),
        onPressed: onTap,
        child: Text(label));
  }
}
