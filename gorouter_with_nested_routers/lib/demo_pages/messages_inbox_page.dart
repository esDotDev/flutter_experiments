import 'package:flutter/material.dart';

// TODO: Add list of messages, that load the MessageDetailView
class InboxPage extends StatelessWidget {
  const InboxPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(), body: const Center(child: Text("Inbox", style: TextStyle(fontSize: 42))));
}
