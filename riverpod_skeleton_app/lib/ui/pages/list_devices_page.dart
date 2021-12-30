import 'package:flutter/material.dart';
import 'package:flutter_app/logic/data/bluetooth_device_info.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/ui/common/distance_text.dart';
import 'package:flutter_app/ui/modals/ok_cancel_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListDevicesPage extends ConsumerWidget {
  ListDevicesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(bluetooth.select((b) => b.visibleDevices.value));
    print('build deviceList, ${devices.length}');
    return ListView(
      children: devices.map(_DeviceListTile.new).toList(),
    );
  }
}

/// Renders info for a single bluetooth device.
/// Triggers the [bluetooth.addIgnoredDevice] action on tap
class _DeviceListTile extends ConsumerWidget {
  _DeviceListTile(this.device, {Key? key}) : super(key: key);
  final BtDeviceInfo device;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// This method could be moved into something like `AppManager.confirmAndIgnoreDevice(device)` action,
    /// which would make sense if this logical flow is repeated in more than one view
    void handleDeviceTap() async {
      const dialog = OkCancelDialog(title: 'Ignore device', desc: 'Are you sure?');
      bool? ignore = await ref.read(app).openDialog(context, dialog);
      if (ignore ?? false) {
        ref.read(bluetooth).addIgnoredDevice(device);
      }
    }

    return ListTile(
        onTap: handleDeviceTap,
        contentPadding: const EdgeInsets.all(16),
        title: Text(device.name),
        trailing: DistanceText(distance: device.distance));
  }
}
