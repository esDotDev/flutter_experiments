import 'package:flutter/foundation.dart';
import 'package:state_management_comparisons/shared/services/file_service.dart';

class AppManager with ChangeNotifier {
  AppManager(this.locateFileService) {
    locateFileService().loadFile('app.sav');
  }
  final FileService Function() locateFileService;

  int _count1 = 0;
  int get count1 => _count1;
  set count1(int value) {
    _count1 = value;
    notifyListeners();
  }

  int _count2 = 0;
  int get count2 => _count2;
  set count2(int value) {
    _count2 = value;
    notifyListeners();
  }
}
