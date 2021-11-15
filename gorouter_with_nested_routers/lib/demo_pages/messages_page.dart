import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../go_routers.dart';
import '../main.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  int _count = 0;
  set count(int value) {
    setState(() => _count = value);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          body: Scaffold(
        appBar: AppBar(title: const Text("Messages")),
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton(
                child: const Text("INBOX", style: TextStyle(fontSize: 42)),
                onPressed: () {
                  // todo: fix: currently we have to call .go on both the child and parent routers,
                  context.go('$messagesPath/$messagesInboxPath');
                  rootGoRouter.go('$messagesPath/$messagesOutboxPath');
                }),
            OutlinedButton(
                child: const Text("OUTBOX", style: TextStyle(fontSize: 42)),
                onPressed: () {
                  // todo: fix: currently we have to call .go on both the child and parent routers,
                  context.go('$messagesPath/$messagesOutboxPath');
                  rootGoRouter.go('$messagesPath/$messagesOutboxPath');
                }),
            OutlinedButton(
              child: Text("counter = $_count", style: const TextStyle(fontSize: 42)),
              onPressed: () => count = _count + 1,
            ),
          ],
        )),
      ));
}
