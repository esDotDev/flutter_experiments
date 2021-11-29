import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management_comparisons/shared/ui/main_content_page.dart';
import '../shared/managers/app_manager.dart';
import '../shared/ui/randomly_colored_tappable_box.dart';
import '../shared/managers/settings_manager.dart';
import '../shared/services/file_service.dart';

final fileServiceProvider = Provider((_) => FileService());
final settingsManagerProvider = ChangeNotifierProvider((ref) {
  return SettingsManager(() => ref.read(fileServiceProvider));
});
final appManagerProvider = ChangeNotifierProvider((ref) {
  return AppManager(() => ref.read(fileServiceProvider));
});

class RiverpodExample extends StatelessWidget {
  const RiverpodExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [fileServiceProvider.overrideWithValue(MockFileService())],
      child: MainContentPage('RIVERPOD', leftSide: View1(), rightSide: View2()),
    );
  }
}

class View1 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void handleTap() => ref.read(appManagerProvider).count1++;
    int count = ref.watch(appManagerProvider.select((p) => p.count1));
    return RandomlyColoredTappableBox(content: 'count1: $count', onTap: handleTap);
  }
}

class View2 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void handleTap() => ref.read(appManagerProvider).count2++;
    int count = ref.watch(appManagerProvider.select((p) => p.count2));
    return RandomlyColoredTappableBox(content: 'count2: $count', onTap: handleTap);
  }
}
