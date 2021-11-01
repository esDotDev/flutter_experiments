import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';

// TODO: Add inbox/outbox btns
class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  int _count = 0;
  static const ValueKey _countKey = ValueKey('_MessagesPageState_count');

  set count(int value) {
    setState(() => _count = value);
    pageBucket.writeState(context, _count, identifier: _countKey);
  }

  @override
  void initState() {
    super.initState();
    _count = pageBucket.readState(context, identifier: _countKey) ?? 0;
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
                  context.go('${PagePaths.messages}/${PagePaths.messagesInbox}');
                }),
            OutlinedButton(
                child: const Text("OUTBOX", style: TextStyle(fontSize: 42)),
                onPressed: () {
                  context.go('${PagePaths.messages}/${PagePaths.messagesOutbox}');
                }),
            OutlinedButton(
              child: Text("counter = $_count", style: const TextStyle(fontSize: 42)),
              onPressed: () => count = _count + 1,
            ),
          ],
        )),
      ));
}
