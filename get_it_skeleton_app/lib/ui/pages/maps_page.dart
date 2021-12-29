import 'package:flutter/material.dart';
import 'package:flutter_app/logic/maps_manager.dart';
import 'package:flutter_app/logic/purchases_manager.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/ui/common/buttons.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class MapPage extends StatelessWidget with GetItMixin {
  MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Show a bottom sheet when the purchase button is tapped
    void handlePurchaseTap() => purchases.showSheetIfRequired(context);
    // Allows us to show error if maps has not been initialized.
    bool isMapsAvailable = watchX((MapsManager m) => m.isAvailable);
    // Allows us to show an overlay and upgrade btn if the app is not in pro mode.
    bool isProEnabled = watchX((PurchasesManager p) => p.isProEnabled);

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
