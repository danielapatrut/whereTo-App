import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:where_to_app/services/geolocator_service.dart';

class ApplicationBloc with ChangeNotifier {

  final geoLocatorService = GeolocatorService();

  //Variables
  late Position currentLocation;

  ApplicationBloc()
  {
    setCurrentLocation();
  }

  setCurrentLocation() async {
    currentLocation = await geoLocatorService.getCurrentLocation();
    notifyListeners();
  }
}