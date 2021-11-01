import 'package:equatable/equatable.dart';

/// Wraps a list and performs a deep comparison on it for equality checks
class EquatableList<T> with EquatableMixin {
  EquatableList(this.data);
  final List<T> data;

  @override
  List<Object?> get props => data;
}
