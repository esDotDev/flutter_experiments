import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management_comparisons/shared/ui/main_content_page.dart';
import '../shared/managers/app_manager.dart';
import '../shared/ui/randomly_colored_tappable_box.dart';
import '../shared/managers/settings_manager.dart';
import '../shared/services/file_service.dart';

class ProviderExample extends StatelessWidget {
  const ProviderExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => FileService()),
        ChangeNotifierProvider(create: (context) {
          return SettingsManager(() => context.read<FileService>());
        }),
        ChangeNotifierProvider(create: (context) {
          return AppManager(() => context.read<FileService>());
        }),
      ],
      child: MainContentPage('PROVIDER', leftSide: View1(), rightSide: View2()),
    );
  }
}

class View1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void handleTap() => context.read<AppManager>().count1++;
    int count = context.select((AppManager m) => m.count1);
    return RandomlyColoredTappableBox(content: 'count1: $count', onTap: handleTap);
  }
}

class View2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void handleTap() => context.read<AppManager>().count2++;
    int count = context.select((AppManager m) => m.count2);
    return RandomlyColoredTappableBox(content: 'count2: $count', onTap: handleTap);
  }
}
