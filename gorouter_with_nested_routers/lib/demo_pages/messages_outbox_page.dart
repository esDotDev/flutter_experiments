import 'package:flutter/material.dart';

// todo: Add list of messages, that load the MessageDetailView
class OutboxPage extends StatelessWidget {
  const OutboxPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(), body: const Center(child: Text("Outbox", style: TextStyle(fontSize: 42))));
}

class MessageDetailView extends StatelessWidget {
  const MessageDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text("$this", style: const TextStyle(fontSize: 42))));
}
