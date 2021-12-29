import 'package:flutter_app/logic/bluetooth_service.dart';
import 'package:flutter_app/logic/data/bluetooth_device_info.dart';

class BlueToothServiceMock extends BlueToothService {
  @override
  void startScan() {
    final devices = [
      BtDeviceInfo('id0', 'title 0', 0),
      BtDeviceInfo('id1', 'title 1', 1),
      BtDeviceInfo('id2', 'title 2', 2),
      BtDeviceInfo('id3', 'title 3', 3),
      BtDeviceInfo('id4', 'title 4', 4),
      BtDeviceInfo('id5', 'title 5', 5),
      BtDeviceInfo('id6', 'title 6', 6),
      BtDeviceInfo('id7', 'title 7', 7),
    ];
    for (var d in devices) {
      onDeviceFound?.call(d);
    }
  }
}
