import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// import 'demo_pages/feed_page.dart';
// import 'demo_pages/feed_settings_page.dart';
// import 'demo_pages/messages_inbox_page.dart';
// import 'demo_pages/messages_outbox_page.dart';
// import 'demo_pages/messages_page.dart';

void main() => runApp(const GoRouteBuildersDemo());

class GoRouteBuildersDemo extends StatefulWidget {
  const GoRouteBuildersDemo({Key? key}) : super(key: key);

  @override
  State<GoRouteBuildersDemo> createState() => _GoRouteBuildersDemoState();
}

class _GoRouteBuildersDemoState extends State<GoRouteBuildersDemo> {
  MaterialPage createPage(ValueKey key, Widget child) => MaterialPage(child: child, key: key);
  late GoRouter goRouter = GoRouter(
    navigatorBuilder: (_, child) {
      // on login route, no scaffold
      if (goRouter.location == '/') {
        return child!;
      }
      // on a page under /app/settings? add a settings menu
      if (goRouter.location.startsWith('/app/settings')) {
        child = SettingsMenu(child: child!);
      }
      // add main scaffold to all other pages
      return MainScaffold(child: child!);
    },
    routes: [
      // No scaffold for login page
      GoRoute(path: '/', pageBuilder: (_, __) => const MaterialPage(child: LoginPage())),

      // All /app pages get the main scaffold
      GoRoute(
        //navigatorBuilder: (context, state, child) => MainScaffold(child: child),
        path: '/app',
        pageBuilder: (_, __) => const MaterialPage(child: SizedBox.shrink()),
        routes: [
          GoRoute(path: 'inbox', pageBuilder: (_, state) => createPage(state.pageKey, const InboxPage())),
          // GoRoute(
          //   path: 'settings/',
          //   pageBuilder: (_, __) => const MaterialPage(child: SizedBox.shrink()),
          //   //navigatorBuilder: (context, state, child) => SettingsMenu(child: child),
          //   routes: [
          //     GoRoute(path: 'general', pageBuilder: (_, s) => createPage(s.pageKey, const GeneralPage())),
          //     GoRoute(path: 'accounts', pageBuilder: (_, s) => createPage(s.pageKey, const AccountsPage())),
          //     GoRoute(path: 'filters', pageBuilder: (_, s) => createPage(s.pageKey, const FiltersPage())),
          //   ],
          // ),
        ],
      ),
    ],
    errorPageBuilder: (BuildContext context, GoRouterState state) {
      print(state.error);
      return MaterialPage(
        child: Text('${state.error}'),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: goRouter.routeInformationParser,
      routerDelegate: goRouter.routerDelegate,
    );
  }
}

class ContentPage extends StatelessWidget {
  const ContentPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text(title, style: const TextStyle(fontSize: 48))));
}

class LoginPage extends ContentPage {
  const LoginPage({Key? key}) : super(key: key, title: 'LOGIN');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () => context.go('/app/inbox'), child: super.build(context));
  }
}

class InboxPage extends ContentPage {
  const InboxPage({Key? key}) : super(key: key, title: 'INBOX');
}

class GeneralPage extends ContentPage {
  const GeneralPage({Key? key}) : super(key: key, title: 'GeneralPage');
}

class AccountsPage extends ContentPage {
  const AccountsPage({Key? key}) : super(key: key, title: 'AccountsPage');
}

class FiltersPage extends ContentPage {
  const FiltersPage({Key? key}) : super(key: key, title: 'FiltersPage');
}

class MainScaffold extends StatelessWidget {
  const MainScaffold({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    int tabIndex = GoRouter.of(context).location.startsWith('app/settings') ? 1 : 0;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          const Text('APP TITLE', style: TextStyle(fontSize: 32)),
          Expanded(child: child),
          Row(
            children: [
              Expanded(
                  child: TextButton(
                      child: const Text('inbox', style: TextStyle(fontSize: 24)),
                      onPressed: tabIndex == 0 ? null : () => context.go('/app/inbox'))),
              Expanded(
                  child: TextButton(
                      child: const Text('settings', style: TextStyle(fontSize: 24)),
                      onPressed: tabIndex == 1 ? null : () => context.go('/app/settings'))),
            ],
          )
        ],
      ),
    );
  }
}

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> with SingleTickerProviderStateMixin {
  late TabController tabController = TabController(length: 3, vsync: this)
    ..addListener(() {
      print(tabController.index);
    });

  int get tabIndex => tabController.index;

  @override
  Widget build(BuildContext context) {
    String loc = GoRouter.of(context).location;
    int index = 0;
    if (loc.startsWith('settings/accounts')) index = 1;
    if (loc.startsWith('settings/filters')) index = 2;
    if (tabController.index != index) {
      tabController.index = index;
    }

    return FadeIn(
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: Column(
          children: [
            Text('My Settings', style: TextStyle(fontSize: 32)),
            ColoredBox(
              color: Colors.grey.shade300,
              child: TabBar(
                controller: tabController,
                tabs: [
                  TabButton('general', isSelected: tabIndex == 0),
                  TabButton('accounts', isSelected: tabIndex == 1),
                  TabButton('filters', isSelected: tabIndex == 2)
                ],
              ),
            ),
            Expanded(child: widget.child),
          ],
        ),
      ),
    );
  }
}

class TabButton extends StatelessWidget {
  const TabButton(this.label, {Key? key, this.fontSize = 16, required this.isSelected}) : super(key: key);
  final String label;
  final double fontSize;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(fontSize * .66),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }
}

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

// build a history stack manually because go_router doesn't keep track.
router.addListener(() => history.add(router.path));
*/
//
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
  static late String messageDetails = 'message/:messageId';
}
//
// class App extends StatefulWidget {
//   const App({Key? key}) : super(key: key);
//   static final locationHistory = [PagePaths.initial];
//
//   static void recordLocationHistory(String loc) {
//     if (loc != App.locationHistory.first) {
//       // Record location history, newest items are at the front of the list
//       App.locationHistory.insert(0, loc);
//       debugPrint("Record goRouterhistory: $loc");
//     }
//   }
//
//   @override
//   State<App> createState() => _AppState();
// }
//
// class _AppState extends State<App> {
//   late final GoRouter goRouter;
//
//   @override
//   void initState() {
//     super.initState();
//     MaterialPage buildPage(Widget child, GoRouterState state) => MaterialPage(child: child, key: state.pageKey);
//
//     goRouter = GoRouter(
//       initialLocation: PagePaths.initial,
//       navigatorBuilder: (_, navigator) {
//         return _TabScaffold(
//           navigator!,
//           [
//             _SmartTabBtn(PagePaths.feed),
//             _SmartTabBtn(PagePaths.messages),
//           ],
//         );
//       },
//       routes: [
//         // Feed tab stack
//         GoRoute(
//           path: PagePaths.feed,
//           pageBuilder: (_, state) => buildPage(const FeedPage(), state),
//           routes: [
//             GoRoute(path: PagePaths.feedSettings, pageBuilder: (_, s) => buildPage(const FeedSettingsPage(), s)),
//           ],
//         ),
//         // Messages tab stack
//         GoRoute(
//           path: PagePaths.messages,
//           pageBuilder: (_, s) => buildPage(const MessagesPage(), s),
//           routes: [
//             GoRoute(path: PagePaths.messagesInbox, pageBuilder: (_, s) => buildPage(const InboxPage(), s)),
//             GoRoute(path: PagePaths.messagesOutbox, pageBuilder: (_, s) => buildPage(const OutboxPage(), s)),
//           ],
//         ),
//       ],
//       errorPageBuilder: (_, __) => const MaterialPage(child: Placeholder()),
//     );
//
//     goRouter.addListener(() => App.recordLocationHistory(goRouter.location));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       routeInformationParser: goRouter.routeInformationParser,
//       routerDelegate: goRouter.routerDelegate,
//     );
//   }
// }
//
// /// These buttons contain some imperative logic to simulate multiple tab stacks.
// /// Highlevel onPress Logic:
// /// IF we are the currently selected tab, goto the root view of our tab stack
// /// ELSE, we're not currently selected, try and find the last location path that contains our path
// ///  -> IF we found a matching location in the history, go there.
// ///     ELSE, we couldn't find a match, load the root view
// class _SmartTabBtn extends StatelessWidget {
//   const _SmartTabBtn(this.basePath, {Key? key}) : super(key: key);
//   final String basePath;
//
//   @override
//   Widget build(BuildContext context) {
//     GoRouter router = GoRouter.of(context);
//     bool isSelected = router.location.contains(basePath);
//     return CupertinoButton(
//         color: isSelected ? Colors.grey : null, child: Text(basePath), onPressed: () => _handleBtnPressed(router));
//   }
//
//   void _handleBtnPressed(GoRouter router) {
//     // Assume we're going to link to our basePath which is the common case
//     String newPath = basePath;
//     // If we're not currently selected, attempt to restore the last page the user was viewing for this tab.
//     bool isNotSelected = router.location.contains(basePath) == false;
//     if (isNotSelected) {
//       // Look for most recent location that contains our basePath.
//       bool match(String s) => s.contains(basePath);
//       String mostRecentSubPage = App.locationHistory.firstWhere(match, orElse: () => '');
//       // If we found a match, use it. Otherwise fall back to the basePath.
//       if (mostRecentSubPage.isNotEmpty) {
//         newPath = mostRecentSubPage;
//       }
//     }
//     router.go(newPath);
//   }
// }
//
// /// Basic tab layout. Puts an Expanded 'content' widget in a column, with a row of btns on the bottom.
// /// This could represent any type of persistent menu system (desktop style side menu, web style top navigation, sliding drawer etc).
// class _TabScaffold extends StatelessWidget {
//   const _TabScaffold(this.content, this.btns, {Key? key}) : super(key: key);
//   final List<Widget> btns;
//   final Widget content;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Expanded(child: content),
//           Row(children: btns.map((btn) => Expanded(child: btn)).toList()),
//         ],
//       ),
//     );
//   }
// }
