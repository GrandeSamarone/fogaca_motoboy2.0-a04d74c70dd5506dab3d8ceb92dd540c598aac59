import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as lc;

import 'package:permission_handler/permission_handler.dart';

class LocationController extends ChangeNotifier {
  bool gpsEnabled = false;

  LocationController() {
    hasLocationPermission();
  }

  hasLocationPermission() async {
    var status = await Permission.location.serviceStatus;
    gpsEnabled = status == ServiceStatus.enabled;
    notifyListeners();
  }

  enableGps() async {
    gpsEnabled = await lc.Location.instance.requestService();
    print('ENABLEGPS');
    print(gpsEnabled);
    await hasLocationPermission();
  }
}
