import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'demo_pages/feed_page.dart';
import 'demo_pages/feed_settings_page.dart';
import 'demo_pages/messages_inbox_page.dart';
import 'demo_pages/messages_outbox_page.dart';
import 'demo_pages/messages_page.dart';
import 'main.dart';

MaterialPage buildPage(Widget child, ValueKey? key) => MaterialPage(child: child, key: key);

late final GoRouter rootGoRouter = GoRouter(
  initialLocation: initialPath,
  routes: [
    /// We want to let all the routes flow down to the child routes, simply parsing the `/tab/`
    /// portion of the url at this point.
    /// Currently it's implemented in a pretty awkward way in by declaring multiple routes with different paths,
    /// pointing to the same view and using the same key (or no key)
    /// todo: add some wild-card / pass-through syntax, so we can use a single `GoRoute` with `path: '/*'`,
    GoRoute(
      path: '/:tab',
      pageBuilder: (_, state) {
        return buildPage(TabScaffold(state.params['tab'] ?? ''), null);
      },
    ),
    // Need to declare these redundant routes,
    // otherwise something like `/messages/inbox` will throw a non-matching error
    GoRoute(
      path: '/:tab/:foo',
      pageBuilder: (_, state) {
        return buildPage(TabScaffold(state.params['tab'] ?? ''), null);
      },
    ),
    GoRoute(
      path: '/:tab/:foo/:bar',
      pageBuilder: (_, state) {
        return buildPage(TabScaffold(state.params['tab'] ?? ''), null);
      },
    ),
  ],
  errorPageBuilder: (_, s) => MaterialPage(child: ErrorPage(s.error)),
);

final GoRouter messageRouter = GoRouter(
  initialLocation: messagesPath,
  routes: [
    // Messages tab stack
    GoRoute(
      // /messages
      path: messagesPath,
      pageBuilder: (_, s) => buildPage(const MessagesPage(), s.pageKey),
      routes: [
        // /messages/inbox
        GoRoute(
          path: messagesInboxPath,
          pageBuilder: (_, s) => buildPage(const InboxPage(), s.pageKey),
        ),
        // /messages/outbox
        GoRoute(
          path: messagesOutboxPath,
          pageBuilder: (_, s) => buildPage(const OutboxPage(), s.pageKey),
        ),
      ],
    ),
  ],
  errorPageBuilder: (_, s) => MaterialPage(child: ErrorPage(s.error)),
);

final GoRouter feedRouter = GoRouter(
  initialLocation: feedPath,
  routes: [
    // /feed,
    GoRoute(
      path: feedPath,
      pageBuilder: (_, state) => buildPage(const FeedPage(), state.pageKey),
      routes: [
        // /feed/settings
        GoRoute(
          path: feedSettingsPath,
          pageBuilder: (_, s) => buildPage(const FeedSettingsPage(), s.pageKey),
        ),
      ],
    ),
  ],
  errorPageBuilder: (_, s) => MaterialPage(child: ErrorPage(s.error)),
);
