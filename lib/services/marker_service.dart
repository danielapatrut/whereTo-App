import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:where_to_app/models/place.dart';

class MarkerService {



  Marker createMarkedFromPlace(Place place){
    var markerId = place.placeId;

    return Marker(
      markerId: MarkerId(markerId),
    draggable: false,
    infoWindow: InfoWindow(
        title: place.name,
        snippet: place.vicinity),
      position: LatLng(place.geometry.location.lat, place.geometry.location.lng)
    );
  }
}