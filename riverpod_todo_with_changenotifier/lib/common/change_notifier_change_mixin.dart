import 'package:flutter/foundation.dart';

/// A convenience class to enable single line updates + rebuilds, similar to a StatefulWidget.
mixin ChangeNotifierChangeMixin on ChangeNotifier {
  void change([VoidCallback? action]) {
    action?.call();
    notifyListeners();
  }
}
