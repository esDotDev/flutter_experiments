import 'package:flutter/material.dart';
import 'package:flutter_app/logic/settings_manager.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DistanceText extends ConsumerWidget {
  DistanceText({Key? key, required this.distance}) : super(key: key);
  final double distance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool useMetric = ref.watch(settings.select((SettingsManager s) => s.useMetric.value));
    double d = useMetric ? distance : distance * 3.28084;
    String distanceString = d.toStringAsFixed(1);
    distanceString += useMetric ? 'm' : 'ft';
    return Text(distanceString);
  }
}
