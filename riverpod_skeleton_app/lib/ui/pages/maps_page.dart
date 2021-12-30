import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/ui/common/buttons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MapPage extends ConsumerWidget {
  MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Show a bottom sheet when the purchase button is tapped
    void handlePurchaseTap() => ref.read(purchases).showSheetIfRequired(context);
    // Allows us to show error if maps has not been initialized.
    bool isMapsAvailable = ref.watch(maps.select((m) => m.isAvailable.value));
    // Allows us to show an overlay and upgrade btn if the app is not in pro mode.
    bool isProEnabled = ref.watch(purchases.select((p) => p.isProEnabled.value));

    if (isMapsAvailable == false) {
      return const Center(child: Text('Maps is not initialized.'));
    }
    return Stack(children: [
      /// Map
      const Center(
        child: FlutterLogo(size: 350), //Todo: <-- Add map here
      ),

      /// Overlay that blocks the map until pro mode is unlocked
      if (isProEnabled == false) ...[
        Positioned.fill(child: Container(color: Colors.black.withOpacity(.8))),
        Center(
          child: AppBtn(label: 'Upgrade to pro?', onTap: handlePurchaseTap),
        )
      ]
    ]);
  }
}
