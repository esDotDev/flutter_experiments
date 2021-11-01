// class Logic<TActions, TState> {
//   StatefulController(this.actions, this.state);
//   final TActions actions;
//   final TState state;
// }

// final authLogic = LogicProvider(AuthState(), (s) => AuthActions(s));
//
// read(authLogic).actions.login();
// String user = watch(authLogic).state.user;

// A StateNotifier blocks external classes from accessing .state directly.
// This gives the Notifier complete control over the state.
// Can we do the same thing with ChangeNotifier?
// a protected .state value that when assigned, notifies listeners
// downside, it requires immutable data...

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatefulChangeNotifier<T> extends ChangeNotifier {
  StatefulChangeNotifier(this._state);
  T _state;
  T get state => _state;
  @protected
  set state(T state) {
    _state = state;
    notifyListeners();
  }
}

class FooState {
  FooState({this.count = 0});
  final int count;

  FooState copyWith({int? count}) => FooState(count: count ?? this.count);
}

class FooNotifier extends StatefulChangeNotifier<FooState> {
  FooNotifier() : super(FooState());
}

class FooNotifierSN extends StateNotifier<FooState> {
  FooNotifierSN() : super(FooState());
}

// class IntState extends StateNotifier<int> {
//   IntState() : super(0);
//   IntState read() => this;
// }
//
// void test() {
//   IntState f = IntState();
//   debugPrint('${f.read()}');
// }
//
// class StatefulControllerProvider<T1, T2> {}

// class StatefulController {
//   Logic(this.state, AuthActions Function(AuthState state) actionsBuilder) {
//     actions = actionsBuilder(state);
//   }
//   late final AuthActions actions;
//   final AuthState state;
// }
//
// class AuthActions {
//   AuthActions(this.state);
//   AuthState state;
// }
//
// class AuthState {}
