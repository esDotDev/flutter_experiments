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
import 'package:get_it/get_it.dart';

void main() {
  registerSingletons(testMode: true);
  runApp(MainApp());
}

/// Map all shared managers and services
void registerSingletons({bool testMode = false}) {
  GetIt.I.registerLazySingleton(() => AppManager());
  GetIt.I.registerLazySingleton(() => BlueToothManager());
  GetIt.I.registerLazySingleton(() => BlueToothService());
  GetIt.I.registerLazySingleton(() => LocationService());
  GetIt.I.registerLazySingleton(() => MapsManager());
  GetIt.I.registerLazySingleton(() => PurchasesManager());
  GetIt.I.registerLazySingleton(() => SettingsManager());

  if (testMode) {
    GetIt.I.pushNewScope();
    GetIt.I.registerLazySingleton<BlueToothService>(() => BlueToothServiceMock());
    GetIt.I.registerLazySingleton<PurchasesManager>(() => PurchasesManagerMock());
  }
}

/// Create global shortcut methods for common managers and services
final _get = GetIt.I.get;
AppManager get app => _get<AppManager>();
BlueToothManager get bluetooth => _get<BlueToothManager>();
LocationService get location => _get<LocationService>();
MapsManager get maps => _get<MapsManager>();
PurchasesManager get purchases => _get<PurchasesManager>();
SettingsManager get settings => _get<SettingsManager>();
