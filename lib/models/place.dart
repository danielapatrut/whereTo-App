import 'dart:convert';

import 'package:where_to_app/models/geometry.dart';

class Place
{
  Geometry geometry;
  String name;
  String vicinity;
  num? rating;
  List<dynamic>? types;
  num? priceLevel;
  String placeId;

  Place({required this.geometry, required this.name, required this.vicinity, required this.priceLevel,required this.types, required this.rating, required this.placeId});

  factory Place.fromJson(Map<String, dynamic> parsedJson){

    return Place(
      geometry: Geometry.fromJson(parsedJson['geometry']),
      name: parsedJson['name'],
      vicinity: parsedJson['vicinity'],
      rating: parsedJson['rating'],
      priceLevel: parsedJson['price_level'],
      types: parsedJson['types'],
      placeId: parsedJson['place_id']
    );
  }
}