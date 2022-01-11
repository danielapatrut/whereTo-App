import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:where_to_app/blocs/app_bloc.dart';
import 'package:where_to_app/constants/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:where_to_app/models/place.dart';
import 'package:where_to_app/screens/settingsScreen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

bool _isSearchOpen = false;
bool _areResultsVisible = false;
bool _showPlaces = false;
bool _isSurpriseMeOpen = false;

class _HomeScreenState extends State<HomeScreen> {
  final itemsVisited = ["Yes", "No"];
  final itemsDistance = ["100", "200", "500", "1000", "1500"];

  final itemsType = ["cafe", "restaurant", "bar"];
  final itemsRatings = ["1 star" ,"2 stars", "3 stars", "4 stars", "5 stars"];
  final itemsPrice = ["1", "2", "3", "4"];
  String? valueVisited = 'No';
  String? valueDistance = '200';
  String? valueType = 'cafe';
  String? valueRatings = '4 stars';
  String? valuePrice= '2';

  Completer<GoogleMapController> _mapController = Completer();
  late StreamSubscription locationSubscription;

  @override
  void initState() {
    final applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);

    locationSubscription = applicationBloc.selectedLocation.stream.asBroadcastStream().listen((place) {
      if (place != null) {
        _goToPlace(place);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    final applicationBloc =
        Provider.of<ApplicationBloc>(context, listen: false);
    applicationBloc.dispose();
    locationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return Scaffold(
      body: (applicationBloc.currentLocation == null)
          ? Center(
              child: CircularProgressIndicator(
                color: defaultColor,
              ),
            )
          : Stack(
              children: [
                Positioned.fill(
                    child: GoogleMap(
                        mapType: MapType.normal,
                        markers: Set<Marker>.of(applicationBloc.markers),
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                              applicationBloc.currentLocation!.latitude,
                              applicationBloc.currentLocation!.longitude),
                          zoom: 14,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          _mapController.complete(controller);
                        },
                        padding: EdgeInsets.only(
                          top: 40.0,
                        ))),
                Positioned(
                    top: 57,
                    left: 12,
                    child: Visibility(
                      visible: !_isSearchOpen,
                      child: ElevatedButton(
                        child: Icon(Icons.menu, color: Colors.white),
                        style: ElevatedButton.styleFrom(
                            primary: defaultColor,
                            fixedSize: Size(40, 40),
                            shape: CircleBorder()),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SettingsScreen()));
                        },
                      ),
                    )),
                Positioned(
                    top: 57,
                    right: 12,
                    child: Visibility(
                      visible: !_isSearchOpen,
                      child: ElevatedButton(
                        child: Icon(Icons.search, color: Colors.white),
                        style: ElevatedButton.styleFrom(
                            primary: defaultColor,
                            fixedSize: Size(40, 40),
                            shape: CircleBorder()),
                        onPressed: () => setState(() {
                          _isSearchOpen = true;
                          _areResultsVisible = true;
                        }),
                      ),
                    )),
                Positioned(
                  bottom: 100,
                  right: 12,
                  child: Column(children: [
                    Visibility(
                      visible: !_isSearchOpen,
                      child: FilterChip(
                        label: Icon(Icons.local_restaurant_rounded,
                            color: Colors.white),
                        onSelected: (val) {
                          applicationBloc.toggleNearbyPlaces('restaurant', val);
                          _showPlaces = !_showPlaces;
                        },
                        selected: applicationBloc.placeType == 'restaurant',
                        selectedColor: defaultColor,
                      ),
                    ),
                    Visibility(
                      visible: !_isSearchOpen,
                      child: FilterChip(
                        label:
                            Icon(Icons.local_cafe_rounded, color: Colors.white),
                        onSelected: (val) {
                          applicationBloc.toggleNearbyPlaces('cafe', val);
                          _showPlaces = !_showPlaces;
                        },
                        selected: applicationBloc.placeType == 'cafe',
                        selectedColor: defaultColor,
                      ),
                    ),
                    Visibility(
                      visible: !_isSearchOpen,
                      child: FilterChip(
                        label:
                            Icon(Icons.local_bar_rounded, color: Colors.white),
                        onSelected: (val) {
                          applicationBloc.toggleNearbyPlaces('bar', val);
                          _showPlaces = !_showPlaces;
                        },
                        selected: applicationBloc.placeType == 'bar',
                        selectedColor: defaultColor,
                      ),
                    )
                  ]),
                ),
                Positioned(
                    bottom: 50,
                    left: 60,
                    right: 60,
                    child: Visibility(
                      visible: !_isSurpriseMeOpen,
                      child: ElevatedButton(
                        child: Text('Surpise me!'),
                        style: ElevatedButton.styleFrom(
                            primary: defaultColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        onPressed: () =>
                            setState(() => _isSurpriseMeOpen = true),
                      ),
                    )),
                Positioned(
                  top: 10,
                  right: 20,
                  left: 20,
                  child: Visibility(
                    visible: _isSearchOpen,
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Search',
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey),
                              borderRadius: BorderRadius.circular(25)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey),
                              borderRadius: BorderRadius.circular(25)),
                          prefixIcon: IconButton(
                              onPressed: () => setState(() {
                                    _isSearchOpen = false;
                                    _areResultsVisible = false;
                                  }),
                              icon:
                                  Icon(Icons.arrow_back, color: defaultColor)),
                          suffixIcon: Icon(Icons.search, color: defaultColor)),
                      onChanged: (value) => applicationBloc.searchPlaces(value),
                    ),
                  ),
                ),
                if (applicationBloc.searchResults != null &&
                    applicationBloc.searchResults.length != 0 &&
                    _areResultsVisible)
                  Stack(
                    children: [
                      Positioned(
                        top: 70,
                        left: 20,
                        right: 20,
                        child: Container(
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 70,
                        left: 20,
                        right: 20,
                        child: Container(
                          height: 300,
                          child: ListView.builder(
                              itemCount: applicationBloc.searchResults.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    applicationBloc
                                        .searchResults[index].description,
                                    style: TextStyle(color: defaultColor),
                                  ),
                                  onTap: () {
                                    applicationBloc.setSelectedLocation(
                                        applicationBloc
                                            .searchResults[index].placeId);
                                    _areResultsVisible = false;
                                    _isSearchOpen = false;
                                  },
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                Positioned(
                  top: 350,
                  right: 10,
                  left: 10,
                  bottom: 60,
                  child: Visibility(
                    visible: _isSurpriseMeOpen,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          IconButton(
                              onPressed: () =>
                                  setState(() => _isSurpriseMeOpen = false),
                              icon:
                                  Icon(Icons.arrow_back, color: defaultColor)),
                          Container(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildRow('Visited'),
                                Container(
                                    height: 30,
                                    child: DropdownButton<String>(
                                      value: valueVisited,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 30,
                                      underline: SizedBox(),
                                      items: itemsVisited.map(buildItem).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          this.valueVisited = newValue;
                                        });
                                      },
                                    ),),
                              ],
                            ),
                          ),
                          Container(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildRow('Distance'),
                                Container(
                                  height: 30,
                                  child: DropdownButton<String>(
                                    value: valueDistance,
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 30,
                                    underline: SizedBox(),
                                    items: itemsDistance.map(buildItem).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        this.valueDistance = newValue;
                                      });
                                    },
                                  ),),
                              ],
                            ),
                          ),
                          Container(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildRow('Type'),
                                Container(
                                  height: 30,
                                  child: DropdownButton<String>(
                                    value: valueType,
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 30,
                                    underline: SizedBox(),
                                    items: itemsType.map(buildItem).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        this.valueType = newValue;
                                      });
                                    },
                                  ),),
                              ],
                            ),
                          ),
                          Container(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildRow('Rating'),
                                Container(
                                  height: 30,
                                  child: DropdownButton<String>(
                                    value: valueRatings,
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 30,
                                    underline: SizedBox(),
                                    items: itemsRatings.map(buildItem).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        this.valueRatings = newValue;
                                      });
                                    },
                                  ),),
                              ],
                            ),
                          ),
                          Container(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildRow('Price level'),
                                Container(
                                  height: 30,
                                  child: DropdownButton<String>(
                                    value: valuePrice,
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 30,
                                    underline: SizedBox(),
                                    items: itemsPrice.map(buildItem).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        this.valuePrice = newValue;
                                      });
                                    },
                                  ),),
                              ],
                            ),
                          ),

                          SizedBox(height: 12),
                          SizedBox(
                              child: ElevatedButton(
                            child: Text('Surpise!'),
                            style: ElevatedButton.styleFrom(
                                primary: defaultColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () {
                              bool ok = true;
                              var visited;
                              num? minRating;
                              if (valueVisited == "Yes")
                                {
                                   visited = true;
                                }
                              else if (valueVisited == "No")
                              {
                                visited = false;
                              }
                              else
                                {
                                  visited = null;
                                  ok = false;
                                }

                              if (valueRatings == "1 star")
                                {
                                  minRating = 1;
                                }
                              else if (valueRatings == "2 stars")
                              {
                                minRating = 2;
                              }
                              else if (valueRatings == "3 stars")
                              {
                                minRating = 3;
                              }
                              else if (valueRatings == "4 stars")
                              {
                                minRating = 4;
                              }
                              else if (valueRatings == "5 stars")
                              {
                                minRating = 5;
                              }
                              else
                              {
                                minRating = null;
                              }

                              if (ok && valueRatings!=null && valueVisited!=null && valuePrice != null
                              && valueType != null && valueDistance != null)
                                {
                                  print(minRating);
                                  print(visited);
                                  print(valuePrice);
                                  print(valueType);
                                  print(valueDistance);
                                  applicationBloc.getSurprisePlace(valueType!,
                                      minRating!, valuePrice!, valueDistance!, visited);
                                  setState(() {
                                    _isSurpriseMeOpen = false;
                                  });
                                }


                            },
                          ))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _goToPlace(Place place) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target:
            LatLng(place.geometry.location.lat, place.geometry.location.lng),
        zoom: 14.0)));
  }
  Widget _buildRow(String name ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child:
          Container(
            child:
              SizedBox(width: 150,
              child: Text(name,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.left,
                style: TextStyle(
                  height: 1.171875,
                  fontSize: 16.0,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 125, 48, 185),),),
          ),)
      );
  }


  DropdownMenuItem<String> buildItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(
              height: 1.171875,
              fontSize: 16.0,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w700,
              color: Colors.black),
        ),
      );
}
