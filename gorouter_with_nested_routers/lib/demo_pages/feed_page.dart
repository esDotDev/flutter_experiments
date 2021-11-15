import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../go_routers.dart';
import '../main.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$widget')),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Feed Settings'),
                IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      // todo: fix: currently we have to call .go on both the child and parent routers,
                      context.go('$feedPath/$feedSettingsPath');
                      rootGoRouter.go('$feedPath/$feedSettingsPath');
                    }),
              ],
            ),
            Expanded(
              child: ListView(
                children: List.generate(
                  100,
                  (index) => Text('Feed Item $index', style: const TextStyle(fontSize: 32)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
