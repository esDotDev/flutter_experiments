import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:state_management_comparisons/shared/ui/main_content_page.dart';

import '../shared/managers/app_manager.dart';
import '../shared/managers/settings_manager.dart';
import '../shared/services/file_service.dart';
import '../shared/ui/randomly_colored_tappable_box.dart';

final sl = GetIt.I;

class GetItExample extends StatefulWidget {
  const GetItExample({Key? key}) : super(key: key);

  @override
  _GetItExampleState createState() => _GetItExampleState();
}

class _GetItExampleState extends State<GetItExample> {
  _GetItExampleState() {
    sl.registerSingleton(FileService());
    sl.registerSingleton(SettingsManager(() => sl.get<FileService>()));
    sl.registerSingleton(AppManager(() => sl.get<FileService>()));
  }

  @override
  void dispose() {
    sl.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MainContentPage('GET IT', leftSide: View1(), rightSide: View2());
}

class View1 extends StatelessWidget with GetItMixin {
  @override
  Widget build(BuildContext context) {
    void handleTap() => sl.get<AppManager>().count1++;
    int count = watchOnly((AppManager m) => m.count1);
    return RandomlyColoredTappableBox(content: 'count1: $count', onTap: handleTap);
  }
}

class View2 extends StatelessWidget with GetItMixin {
  @override
  Widget build(BuildContext context) {
    void handleTap() => sl.get<AppManager>().count2++;
    int count = watchOnly((AppManager m) => m.count2);
    return RandomlyColoredTappableBox(content: 'count2: $count', onTap: handleTap);
  }
}
