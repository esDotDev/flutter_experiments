import 'package:flutter_app/logic/purchases_manager.dart';
import 'package:riverpod/src/framework.dart';

class PurchasesManagerMock extends PurchasesManager {
  PurchasesManagerMock(Ref ref) : super(ref);

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
