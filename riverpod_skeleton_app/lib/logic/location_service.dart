import 'package:flutter_app/logic/data/lat_lng.dart';

/// A simple service facade that returns the current GPS location of the device
class LocationService {
  Future<LatLng?> getCurrentLocation() async {
    return LatLng(lat: 1, long: 1); // TODO: Implement an actual location service
  }
}
