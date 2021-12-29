import 'package:flutter/cupertino.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/ui/modals/purchase_sheet.dart';

class PurchasesManager {
  final isProEnabled = ValueNotifier<bool>(false);

  Future<void> init() async => print('todo: implement init purchases');

  Future<bool> showSheetIfRequired(BuildContext context) async {
    if (isProEnabled.value == true) return true;
    await app.openSheet(context, const PurchaseSheet());
    return isProEnabled.value;
  }

  Future<void> upgradeToPro() async => print('todo: implement upgradeToPro()');

  Future<void> restorePurchases() async => print('todo:implement restorePurchases()');
}
