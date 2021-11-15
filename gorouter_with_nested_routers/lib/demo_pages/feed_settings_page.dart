import 'package:flutter/material.dart';

// TODO: Add back btn
class FeedSettingsPage extends StatelessWidget {
  const FeedSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(), body: Center(child: Text("$this", style: const TextStyle(fontSize: 42))));
}
