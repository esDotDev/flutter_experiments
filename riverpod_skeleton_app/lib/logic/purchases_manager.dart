import 'package:flutter/cupertino.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/ui/modals/purchase_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PurchasesManager with ChangeNotifier {
  PurchasesManager(this.ref);
  final Ref ref;

  late final isProEnabled = ValueNotifier<bool>(false)..addListener(notifyListeners);

  Future<void> init() async => print('todo: implement init purchases');

  Future<bool> showSheetIfRequired(BuildContext context) async {
    if (isProEnabled.value == true) return true;
    await ref.read(app).openSheet(context, const PurchaseSheet());
    return isProEnabled.value;
  }

  Future<void> upgradeToPro() async => print('todo: implement upgradeToPro()');

  Future<void> restorePurchases() async => print('todo:implement restorePurchases()');
}
