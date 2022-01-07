import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:where_to_app/blocs/app_bloc.dart';
import 'package:where_to_app/constants/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class HomeScreen extends StatefulWidget{
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context)
  {
    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return Scaffold(
      body: (applicationBloc.currentLocation == null)
          ? Center(child: CircularProgressIndicator(),)
      : ListView(
        children: [
          TextField(
            decoration: InputDecoration(hintText: 'Search Location')
          ),
          Container(
            height: 700,
            child: GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(applicationBloc.currentLocation.latitude, applicationBloc.currentLocation.longitude),
                zoom: 14),
            )
          )
        ],
      ),
    );
  }
}