import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'demo_pages/feed_page.dart';
import 'demo_pages/feed_settings_page.dart';
import 'demo_pages/messages_inbox_page.dart';
import 'demo_pages/messages_outbox_page.dart';
import 'demo_pages/messages_page.dart';

void main() => runApp(App());
/*
Create the following list of pages:
/feed
/feed/settings
/messages
/messages/inbox
/messages/outbox

Contained in a tab menu with these btns:
tabBtn('/feed')
tabBtn('/messages')

// build a history stack manually because go_router doesn't keep track.
router.addListener(() => history.add(router.path));
*/

PageStorageBucket pageBucket = PageStorageBucket();

class PagePaths {
  static String get initial => feed;

  /// HomeFeed
  static late String feed = '/feed';
  static late String feedSettings = 'feedSettings';

  /// Messages
  static late String messages = '/messages';
  static late String messagesInbox = 'inbox';
  static late String messagesOutbox = 'outbox';
  static late String messageDetails = '/message/:messageId';
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);
  static final locationHistory = [PagePaths.initial];

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
  late final GoRouter goRouter;

  @override
  void initState() {
    super.initState();
    MaterialPage buildPage(Widget child, GoRouterState state) => MaterialPage(child: child, key: state.pageKey);

    goRouter = GoRouter(
      initialLocation: PagePaths.initial,
      navigatorBuilder: (_, navigator) {
        return _TabScaffold(
          navigator!,
          [
            _SmartTabBtn(PagePaths.feed),
            _SmartTabBtn(PagePaths.messages),
          ],
        );
      },
      routes: [
        // User tab stack
        GoRoute(
          path: PagePaths.feed,
          pageBuilder: (_, state) => buildPage(const FeedPage(), state),
          routes: [
            GoRoute(path: PagePaths.feedSettings, pageBuilder: (_, s) => buildPage(const FeedSettingsPage(), s)),
          ],
        ),
        // Messages tab stack
        GoRoute(
          path: PagePaths.messages,
          pageBuilder: (_, s) => buildPage(const MessagesPage(), s),
          routes: [
            GoRoute(path: PagePaths.messagesInbox, pageBuilder: (_, s) => buildPage(const InboxPage(), s)),
            GoRoute(path: PagePaths.messagesOutbox, pageBuilder: (_, s) => buildPage(const OutboxPage(), s)),
          ],
        ),
      ],
      errorPageBuilder: (_, __) => const MaterialPage(child: Placeholder()),
    );

    goRouter.addListener(() => App.recordLocationHistory(goRouter.location));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: goRouter.routeInformationParser,
      routerDelegate: goRouter.routerDelegate,
    );
  }
}

/// These buttons contain some imperative logic to simulate multiple tab stacks.
/// Highlevel onPress Logic:
/// IF we are the currently selected tab, goto the root view of our tab stack
/// ELSE, we're not currently selected, try and find the last location path that contains our path
///  -> IF we found a matching location in the history, go there.
///     ELSE, we couldn't find a match, load the root view
class _SmartTabBtn extends StatelessWidget {
  const _SmartTabBtn(this.basePath, {Key? key}) : super(key: key);
  final String basePath;

  @override
  Widget build(BuildContext context) {
    GoRouter router = GoRouter.of(context);
    bool isSelected = router.location.contains(basePath);
    return CupertinoButton(
        color: isSelected ? Colors.grey : null, child: Text(basePath), onPressed: () => _handleBtnPressed(router));
  }

  void _handleBtnPressed(GoRouter router) {
    // Assume we're going to link to our basePath which is the common case
    String newPath = basePath;
    // If we're not currently selected, attempt to restore the last page the user was viewing for this tab.
    bool isNotSelected = router.location.contains(basePath) == false;
    if (isNotSelected) {
      // Look for most recent location that contains our basePath.
      bool match(String s) => s.contains(basePath);
      String mostRecentSubPage = App.locationHistory.firstWhere(match, orElse: () => '');
      // If we found a match, use it. Otherwise fall back to the basePath.
      if (mostRecentSubPage.isNotEmpty) {
        newPath = mostRecentSubPage;
      }
    }
    router.go(newPath);
  }
}

/// Basic tab layer. Puts an Expanded 'content' widget in a column, with a row of btns on the bottom.
/// This could represent any type of persistent menu system (desktop style side menu, web style top navigation, sliding drawer etc).
class _TabScaffold extends StatelessWidget {
  const _TabScaffold(this.content, this.btns, {Key? key}) : super(key: key);
  final List<Widget> btns;
  final Widget content;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: content),
          Row(children: btns.map((btn) => Expanded(child: btn)).toList()),
        ],
      ),
    );
  }
}
