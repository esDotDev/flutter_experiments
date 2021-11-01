import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return PageStorage(
      bucket: pageBucket,
      child: Scaffold(
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
                        context.go('${PagePaths.feed}/${PagePaths.feedSettings}');
                      }),
                ],
              ),
              Expanded(
                child: ListView(
                    key: const PageStorageKey('feedPage-List1'),
                    children: List.generate(100, (index) => Text('Feed Item $index', style: TextStyle(fontSize: 32)))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
