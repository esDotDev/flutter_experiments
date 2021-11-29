import 'package:flutter/foundation.dart';
import 'package:state_management_comparisons/shared/services/file_service.dart';

class SettingsManager with ChangeNotifier {
  SettingsManager(this.locateFileService) {
    locateFileService().loadFile('settings.sav');
  }
  final FileService Function() locateFileService;
}
