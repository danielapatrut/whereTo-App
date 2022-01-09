import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:where_to_app/blocs/app_bloc.dart';
import 'package:where_to_app/constants/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:where_to_app/models/place.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

bool _isSearchOpen = false;
bool _areResultsVisible = false;
bool _showPlaces = false;

class _HomeScreenState extends State<HomeScreen> {

  Completer<GoogleMapController> _mapController = Completer();
  late StreamSubscription locationSubscription;

  @override
  void initState() {
    final applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);

    locationSubscription = applicationBloc.selectedLocation.stream.listen((place) {
      if (place != null) {
        _goToPlace(place);
      }
    });

    super.initState();
  }


  @override
  void dispose()
  {
    final applicationBloc = Provider.of<ApplicationBloc>(context, listen: false);
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
              child: CircularProgressIndicator(),
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
                                applicationBloc.currentLocation.latitude,
                                applicationBloc.currentLocation.longitude),
                            zoom: 14,),
                        onMapCreated: (GoogleMapController controller){
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
                          onPressed: () => setState(() {_isSearchOpen = true;
                          _areResultsVisible = true;}),
                        ),
                      )),
                    Positioned(
                          bottom: 100,
                          right: 12,
                      child: Column(
                        children: [
                          Visibility(
                              visible: !_isSearchOpen,
                              child: FilterChip(
                                label: Icon(Icons.local_restaurant_rounded, color: Colors.white),
                                onSelected: (val) {applicationBloc.toggleNearbyPlaces('restaurant',val);
                                _showPlaces = !_showPlaces;},
                                selected: applicationBloc.placeType == 'restaurant',
                                selectedColor: defaultColor,
                              ),
                            ),
                          Visibility(
                            visible: !_isSearchOpen,
                            child: FilterChip(
                              label: Icon(Icons.local_cafe_rounded, color: Colors.white),
                              onSelected: (val) {applicationBloc.toggleNearbyPlaces('cafe',val);
                              _showPlaces = !_showPlaces;},
                              selected: applicationBloc.placeType == 'cafe',
                              selectedColor: defaultColor,
                            ),
                          ),
                          Visibility(
                            visible: !_isSearchOpen,
                            child: FilterChip(
                              label: Icon(Icons.local_bar_rounded, color: Colors.white),
                              onSelected: (val) {applicationBloc.toggleNearbyPlaces('bar',val);
                              _showPlaces = !_showPlaces;},
                              selected: applicationBloc.placeType == 'bar',
                              selectedColor: defaultColor,
                            ),
                          )
                        ]
                      ),
                    ),
                Positioned(
                    bottom: 50,
                    left: 60,
                    right: 60,
                    child: ElevatedButton(
                      child: Text('Surpise me!'),
                      style: ElevatedButton.styleFrom(
                          primary: defaultColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {},
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
                                borderRadius: BorderRadius.circular(25)
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blueGrey),
                                borderRadius: BorderRadius.circular(25)
                            ),
                            prefixIcon: IconButton( onPressed: () => setState((){_isSearchOpen = false;
                            _areResultsVisible = false;}),
                                icon: Icon(Icons.arrow_back, color: defaultColor)),
                            suffixIcon: Icon(Icons.search, color: defaultColor)
                          ),
                          onChanged: (value) =>
                              applicationBloc.searchPlaces(value),
                        ),
                      ),
                    ),
                if (applicationBloc.searchResults != null && applicationBloc.searchResults.length != 0 && _areResultsVisible)
                Stack(
                  children: [Positioned(
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
                                  applicationBloc.searchResults[index].description,
                                  style: TextStyle(
                                      color: defaultColor
                                  ),
                                ),
                                onTap: () {
                                  applicationBloc.setSelectedLocation(
                                      applicationBloc.searchResults[index].placeId);
                                  _areResultsVisible = false;
                                  _isSearchOpen = false;
                                },
                              );
                            }
                        ),
                      ),
                    )
                  ],
                )
                ,
              ],
            ),
    );
  }
  
  Future<void> _goToPlace(Place place) async
  {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(place.geometry.location.lat, place.geometry.location.lng),zoom: 14.0))
    );
    
  }


}
