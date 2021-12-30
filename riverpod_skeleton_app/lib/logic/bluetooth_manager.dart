import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/logic/bluetooth_service.dart';
import 'package:flutter_app/logic/data/bluetooth_device_info.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages a service that scans bluetooth devices, and exposes that data to the UI.
/// Provides common actions related to bluetooth.
class BlueToothManager with ChangeNotifier {
  BlueToothManager(this.ref);
  final Ref ref;

  // Request a service from riverpod to perform device scanning, this allows us to easily mock it if we need.
  BlueToothService get service => ref.read(bluetoothService);

  // Hold a list of ignored device ids
  final List<String> _ignoredDevices = [];

  // The list of all known devices, as returned from the service
  late final devices = ValueNotifier<List<BtDeviceInfo>>([])..addListener(notifyListeners);

  // A cached sub-set of devices, removing the ignored ones.
  late final visibleDevices = ValueNotifier<List<BtDeviceInfo>>([])..addListener(notifyListeners);

  Future<void> init() async {
    service.onDeviceFound = _handleDeviceFound;
    service.startScan();
  }

  @override
  //TODO: Figure out how to implement this
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
    visibleDevices.value = List.from(
      devices.value.where((d) => _ignoredDevices.contains(d.id) == false).toList(),
    );
  }
}
