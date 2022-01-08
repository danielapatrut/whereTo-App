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

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

bool _isSearchOpen = false;

class _HomeScreenState extends State<HomeScreen> {
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
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(
                                applicationBloc.currentLocation.latitude,
                                applicationBloc.currentLocation.longitude),
                            zoom: 14),
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
                          onPressed: () => setState(() => _isSearchOpen = !_isSearchOpen),
                        ),
                      )),
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
                      right: 55,
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
                            prefixIcon: IconButton( onPressed: () => setState(() => _isSearchOpen = false),
                                icon: Icon(Icons.arrow_back, color: defaultColor)),
                            suffixIcon: Icon(Icons.search, color: defaultColor)
                          ),
                        ),
                      ),
                    ),
              ],
            ),
    );
  }
}
