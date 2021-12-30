import 'package:flutter/foundation.dart';
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

void main() {
  bool useMocks = kDebugMode;
  runApp(
    ProviderScope(
      overrides: [
        if (useMocks) ...[
          bluetoothService.overrideWithProvider(Provider((_) => BlueToothServiceMock())),
          purchases.overrideWithProvider(
            ChangeNotifierProvider((ref) => PurchasesManagerMock(ref)),
          ),
        ]
      ],
      child: const MainApp(),
    ),
  );
}

// Declare global providers
final app = ChangeNotifierProvider((ref) => AppManager(ref));
// [BlueToothManager] needs to dispose, use riverpods `autoDispose` api
final bluetooth = ChangeNotifierProvider((ref) => BlueToothManager(ref));
final bluetoothService = Provider((ref) => BlueToothService());
final location = Provider((_) => LocationService());
final maps = ChangeNotifierProvider((ref) => MapsManager());
final purchases = ChangeNotifierProvider((ref) => PurchasesManager(ref));
final settings = ChangeNotifierProvider((ref) => SettingsManager(ref));
