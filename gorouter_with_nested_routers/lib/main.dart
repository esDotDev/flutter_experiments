import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'go_routers.dart';

void main() => runApp(const MaterialApp(home: App()));

/*
Create the following list of pages:
/feed
/feed/feedSettings
/messages
/messages/inbox
/messages/outbox

Contained in a tab menu with these btns:
tabBtn('/feed')
tabBtn('/messages')


// See if we can store the contents of each stack of routes in an indexed stack using nested Routers
// See if we can show a fullscreen route on top of the tab stack, without losing state
 */

String get initialPath => feedPath;

/// HomeFeed
late String feedPath = '/feed';
late String feedSettingsPath = 'feedSettings';

/// Messages
late String messagesPath = '/messages';
late String messagesInboxPath = 'inbox';
late String messagesOutboxPath = 'outbox';

// todo: fix deeplinking/refresh on web. It seems '/messages' is not matching '/:tabId' so goRouter redirects to initial route.
// todo: Add fullscreen message details page... How??
// late String messageDetailsPath = 'message/:messageId';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);
  static final locationHistory = [initialPath];

  static void recordLocationHistory(String loc) {
    if (loc != App.locationHistory.first) {
      // Record location history, newest items are at the front of the list
      App.locationHistory.insert(0, loc);
      debugPrint("Record goRouterhistory: $loc");
    }
  }

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    // todo: fix: Have to listen to both child routers instead of the parent here because the root goRouter will not always dispatch change events when path is changed
    messageRouter.addListener(() => App.recordLocationHistory(messageRouter.location));
    feedRouter.addListener(() => App.recordLocationHistory(feedRouter.location));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: rootGoRouter.routeInformationParser,
      routerDelegate: rootGoRouter.routerDelegate,
    );
  }
}

class TabScaffold extends StatefulWidget {
  const TabScaffold(this.tab, {Key? key}) : super(key: key);
  final String tab;

  @override
  State<TabScaffold> createState() => _TabScaffoldState();
}

class _TabScaffoldState extends State<TabScaffold> {
  @override
  Widget build(BuildContext context) {
    int index = widget.tab == 'feed' ? 1 : 0;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: IndexedStack(
            index: index,
            children: [
              Router(
                routerDelegate: messageRouter.routerDelegate,
                routeInformationParser: messageRouter.routeInformationParser,
              ),
              Router(
                  routerDelegate: feedRouter.routerDelegate, routeInformationParser: feedRouter.routeInformationParser),
            ],
          )),
          Row(children: [
            Expanded(child: _SmartTabBtn(messagesPath, nestedRouter: messageRouter)),
            Expanded(child: _SmartTabBtn(feedPath, nestedRouter: feedRouter)),
          ]),
        ],
      ),
    );
  }
}

/// These buttons contain some imperative logic to make the tab stack appear to remember it's last visited tab.
class _SmartTabBtn extends StatelessWidget {
  const _SmartTabBtn(this.basePath, {Key? key, required this.nestedRouter}) : super(key: key);
  final String basePath;
  final GoRouter nestedRouter;
  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    bool isSelected = router.location.contains(basePath);
    return CupertinoButton(
        color: isSelected ? Colors.grey : null, child: Text(basePath), onPressed: () => _handleBtnPressed(router));
  }

  void _handleBtnPressed(GoRouter router) {
    // Assume we're going to link to our basePath which is the common case
    String newPath = basePath;
    // If we're not currently selected, attempt to restore the last page the user was viewing for this tab.
    final loc = router.location;
    bool isNotSelected = loc.startsWith(basePath) == false && loc != basePath;
    if (isNotSelected) {
      // Look for most recent location that contains our basePath.
      bool match(String s) => s.startsWith(basePath);
      String mostRecentSubPage = App.locationHistory.firstWhere(match, orElse: () => '');
      // If we found a match, use it. Otherwise fall back to the basePath.
      if (mostRecentSubPage.isNotEmpty) {
        newPath = mostRecentSubPage;
      }
    }
    // todo: fix: we have to call .go() on both the child and parent routers
    router.go(newPath);
    nestedRouter.go(newPath);
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage(this.error, {Key? key}) : super(key: key);
  final Exception? error;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(error?.toString() ?? 'page not found'),
              TextButton(
                onPressed: () => context.go('/'),
                child: const Text('Home'),
              ),
            ],
          ),
        ),
      );
}
