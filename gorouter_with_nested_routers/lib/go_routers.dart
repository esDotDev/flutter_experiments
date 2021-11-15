import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'demo_pages/feed_page.dart';
import 'demo_pages/feed_settings_page.dart';
import 'demo_pages/messages_inbox_page.dart';
import 'demo_pages/messages_outbox_page.dart';
import 'demo_pages/messages_page.dart';
import 'main.dart';

late final GoRouter rootGoRouter = GoRouter(
  initialLocation: initialPath,
  routes: [
    GoRoute(
      path: '/:tab',
      pageBuilder: (_, state) {
        return buildPage(TabScaffold(state.params['tab'] ?? ''), null);
      },
    ),
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
        GoRoute(path: messagesInboxPath, pageBuilder: (_, s) => buildPage(const InboxPage(), s.pageKey)),
        // /messages/outbox
        GoRoute(path: messagesOutboxPath, pageBuilder: (_, s) => buildPage(const OutboxPage(), s.pageKey)),
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
        GoRoute(path: feedSettingsPath, pageBuilder: (_, s) => buildPage(const FeedSettingsPage(), s.pageKey)),
      ],
    ),
  ],
  errorPageBuilder: (_, s) => MaterialPage(child: ErrorPage(s.error)),
);
