import 'package:flutter/cupertino.dart';
import 'package:flutter_app/logic/data/lat_lng.dart';

/// Might handle initialization of the Maps API, and holds common tasks related to Maps, like linking out
class MapsManager {
  final isAvailable = ValueNotifier<bool>(false);
  Future<void> init() async {
    print('todo: init maps');
    isAvailable.value = true;
  }

  void openLocation(LatLng loc) => print('todo: openLink');
}
