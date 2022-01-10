import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:where_to_app/models/place.dart';
import 'package:where_to_app/models/place_search.dart';
import 'package:where_to_app/services/geolocator_service.dart';
import 'package:where_to_app/services/marker_service.dart';
import 'package:where_to_app/services/places_service.dart';

class ApplicationBloc with ChangeNotifier {

  final geoLocatorService = GeolocatorService();
  final placesService = PlacesService();
  final markerService = MarkerService();

  //Variables
  late Position currentLocation ;
  late List<PlaceSearch> searchResults = List.empty();
  StreamController<Place> selectedLocation = StreamController<Place>();
  List<Marker> markers = List<Marker>.empty();
  late String placeType = 'none';
  final _firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String _distanceRadius = '1500';


  ApplicationBloc()
  {
    setCurrentLocation();
  }

  setCurrentLocation() async {
    currentLocation = await geoLocatorService.getCurrentLocation();
    notifyListeners();
  }

  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutocomplete(searchTerm);
    notifyListeners();
  }

  setSelectedLocation(String placeId) async {
    var searchedPlace = await placesService.getPlace(placeId);
    markers=[];
    placeType = 'none';
    var newMarker = markerService.createMarkedFromPlace(searchedPlace);
    markers.add(newMarker);
    selectedLocation.add(searchedPlace);
    notifyListeners();
  }

  getSurprisePlace(String type, num minRating, num priceRange, num distance) async
  {
    var places = await placesService.getSurprisePlaces(
        currentLocation.latitude, currentLocation.longitude, type, distance, priceRange);
    for (var place in places)
      {
        if (place.rating == null || place.rating! < minRating)
          {
            places.remove(place);
          }
      }

    if (places.length != 0)
      {
        var _random = new Random();
        int randomPlaceIndex = _random.nextInt(places.length-1);
        setSelectedLocation(places[randomPlaceIndex].placeId);

      }
  }



  @override
  void dispose() {
    selectedLocation.close();
    super.dispose();
  }
  
  toggleNearbyPlaces(String value, bool selected) async
  {
    setCurrentLocation();
    setDistance();
    print(_distanceRadius);
    if (selected){
      placeType = value;
    }
    else {
      placeType = 'none';
      markers=[];
    }
     if (placeType !=  'none') {
      var places = await placesService.getPlaces(
          currentLocation.latitude, currentLocation.longitude, placeType, _distanceRadius);
      markers=[];
      if (places.length >0) {
        for (var place in places)
          {
            var newMarker = markerService.createMarkedFromPlace(place);
            markers.add(newMarker);
          }
      }
    }
    notifyListeners();
  }

  void setDistance() async {
   await _firestoreInstance.collection('users').doc(auth.currentUser?.uid).get()
       .then((value) => {
         _distanceRadius = value.data()!['preferedDistance'].toString()
   });
  }
}