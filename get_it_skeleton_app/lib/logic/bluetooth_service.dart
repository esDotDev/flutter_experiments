import 'dart:async';

import 'package:flutter_app/logic/data/bluetooth_device_info.dart';
import 'package:get_it/get_it.dart';

/// Service that scans for available bluetooth devices and notifies a listener when it finds them.
class BlueToothService with Disposable {
  void Function(BtDeviceInfo device)? onDeviceFound;

  void startScan() => print('todo: implement startScan ');

  void stopScan() => print('todo: implement stopScan');

  @override
  FutureOr onDispose() {
    print('todo: implement BlueToothService.onDispose');
  }
}
