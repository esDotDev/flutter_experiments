import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/ui/common/buttons.dart';
import 'package:gap/gap.dart';

class PurchaseSheet extends StatelessWidget {
  const PurchaseSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void handleCancelTap() async => Navigator.of(context).pop();
    void handleOkTap() async {
      // use the purchases action to complete the upgrade, wait on it until it's done
      await purchases.upgradeToPro();
      Navigator.of(context).pop();
    }

    return Column(
      children: [
        const Gap(100),
        const Text('Upgrade to pro?', style: TextStyle(fontSize: 42)),
        const Spacer(),
        AppBtn(label: 'Ok', onTap: handleOkTap),
        AppBtn(label: 'Cancel', onTap: handleCancelTap),
        const Gap(100),
      ],
    );
  }
}
