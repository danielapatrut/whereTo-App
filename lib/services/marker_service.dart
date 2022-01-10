import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:where_to_app/constants/constants.dart';
import 'package:where_to_app/models/place.dart';
import 'package:where_to_app/screens/homeScreen.dart';

class MarkerService {

  final _firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;


  Marker createMarkedFromPlace(Place place){
    var markerId = place.placeId;

    return Marker(
      markerId: MarkerId(markerId),
    draggable: false,
    infoWindow: InfoWindow(
        title: place.name,
        snippet: place.vicinity,
    onTap: (){
          setPlaceAsVisited(place);
    }),
      position: LatLng(place.geometry.location.lat, place.geometry.location.lng),
    );
  }

  void setPlaceAsVisited(Place place) async
  {
    final snapShot = await _firestoreInstance
        .collection('users')
        .doc(auth.currentUser?.uid).collection('visitedPlaces').doc(place.placeId) // varuId in your case
        .get();

    if (snapShot == null || !snapShot.exists) {
      // Document with id == varuId doesn't exist.
      _firestoreInstance.collection('users').doc(auth.currentUser?.uid)
          .collection('visitedPlaces').doc(place.placeId)
          .set(
          {
            'placeId': place.placeId,
            'name': place.name,
            'address': place.vicinity
          }
      );
      BotToast.showSimpleNotification(title: "Location set as visited",
        titleStyle: TextStyle(color: defaultColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,),
        borderRadius: 20,);
    }
    else
      {
        _firestoreInstance.collection('users').doc(auth.currentUser?.uid).collection('visitedPlaces').doc(place.placeId).delete();
        BotToast.showSimpleNotification(title: "Location set as unvisited",
          titleStyle: TextStyle(color: defaultColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,),
          borderRadius: 20,);
      }

  }
}