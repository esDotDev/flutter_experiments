import 'package:flutter/material.dart';
import 'package:flutter_app/logic/app_manager.dart';
import 'package:flutter_app/logic/bluetooth_manager.dart';
import 'package:flutter_app/logic/bluetooth_service.dart';
import 'package:flutter_app/logic/bluetooth_service_mock.dart';
import 'package:flutter_app/logic/location_service.dart';
import 'package:flutter_app/logic/maps_manager.dart';
import 'package:flutter_app/logic/purchases_manager.dart';
import 'package:flutter_app/logic/purchases_manager_mock.dart';
import 'package:flutter_app/logic/settings_manager.dart';
import 'package:flutter_app/ui/main_app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Add providerScope
// Create providers
// All managers switch to CN's, and add `notifyListeners` hook on each notifier.
// Modify managers or services to take a `ref` if they have external deps.
// GetItMixin > ConsumerWidget
// Modify Build Methods
// Use watch(m => m.select())

void main() {
  runApp(
    ProviderScope(
      overrides: [
        bluetoothService.overrideWithProvider(Provider((_) => BlueToothServiceMock())),
        purchases.overrideWithProvider(ChangeNotifierProvider((ref) => PurchasesManagerMock(ref))),
      ],
      child: const MainApp(),
    ),
  );
}

final app = ChangeNotifierProvider((ref) => AppManager(ref));
final bluetooth = ChangeNotifierProvider((ref) => BlueToothManager(ref));
final bluetoothService = Provider((_) => BlueToothService());
final location = Provider((_) => LocationService());
final maps = ChangeNotifierProvider((ref) => MapsManager());
final purchases = ChangeNotifierProvider((ref) => PurchasesManager(ref));
final settings = ChangeNotifierProvider((ref) => SettingsManager(ref));
