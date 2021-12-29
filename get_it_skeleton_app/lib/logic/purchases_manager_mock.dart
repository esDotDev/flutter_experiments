import 'package:flutter_app/logic/purchases_manager.dart';

class PurchasesManagerMock extends PurchasesManager {
  @override
  Future<void> upgradeToPro() async {
    print('PurchasesManagerMock - upgradeToPro');
    isProEnabled.value = true;
  }

  @override
  Future<void> restorePurchases() async {
    print('PurchasesManagerMock - restorePurchases');
    isProEnabled.value = true;
  }
}
