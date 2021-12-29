import 'package:flutter/material.dart';
import 'package:flutter_app/logic/settings_manager.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class DistanceText extends StatelessWidget with GetItMixin {
  DistanceText({Key? key, required this.distance}) : super(key: key);
  final double distance;

  @override
  Widget build(BuildContext context) {
    bool useMetric = watchX((SettingsManager s) => s.useMetric);
    double d = useMetric ? distance : distance * 3.28084;
    String distanceString = d.toStringAsFixed(1);
    distanceString += useMetric ? 'm' : 'ft';
    return Text(distanceString);
  }
}
