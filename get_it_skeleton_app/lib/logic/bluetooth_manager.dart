import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/logic/bluetooth_service.dart';
import 'package:flutter_app/logic/data/bluetooth_device_info.dart';
import 'package:get_it/get_it.dart';

/// Manages a service that scans bluetooth devices, and exposes that data to the UI.
/// Provides common actions related to bluetooth.
class BlueToothManager with Disposable {
  // Request a service from getIt to perform device scanning, this allows us to easily mock it if we need.
  BlueToothService get service => GetIt.I.get<BlueToothService>();
  // Hold a list of ignored device ids
  final List<String> _ignoredDevices = [];
  // The list of all known devices, as returned from the service
  final devices = ValueNotifier<List<BtDeviceInfo>>([]);
  // A cached sub-set of devices, removing the ignored ones.
  final visibleDevices = ValueNotifier<List<BtDeviceInfo>>([]);

  Future<void> init() async {
    service.onDeviceFound = _handleDeviceFound;
    service.startScan();
  }

  @override
  FutureOr onDispose() async => service.stopScan();

  void _handleDeviceFound(BtDeviceInfo device) {
    // Remove device if it already exists and add it back in to the list
    devices.value.removeWhere((element) => element.id == device.id);
    devices.value = List.from(devices.value)..add(device);
    _updateVisibleDevices();
  }

  /// Actions
  void addIgnoredDevice(BtDeviceInfo value) {
    if (_ignoredDevices.contains(value.id) == false) {
      _ignoredDevices.add(value.id);
    }
    _updateVisibleDevices();
  }

  void _updateVisibleDevices() {
    visibleDevices.value = devices.value.where((d) {
      return _ignoredDevices.contains(d.id) == false;
    }).toList();
  }
}
