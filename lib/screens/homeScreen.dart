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
bool _isSurpriseMeOpen = false;

class _HomeScreenState extends State<HomeScreen> {
  final itemsVisited = ["Yes", "No"];
  final itemsDistance = ["50m", "100m", "200m"];
  final itemsType = ["Cafe", "Restaurant"];
  final itemsRatings = ["2 stars", "3 stars", "4 stars", "5 stars"];
  final itemsPrice= ["50Dollars", "Euro"];
  String? valueVisited = 'No';
  String? valueDistance;
  String? valueType;
  String? valueRatings;
  String? valuePrice;
  String? invalue;

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
                    child: Visibility(
                        visible: !_isSurpriseMeOpen,
                    child: ElevatedButton(
                      child: Text('Surpise me!'),
                      style: ElevatedButton.styleFrom(
                          primary: defaultColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      onPressed: () => setState(() => _isSurpriseMeOpen = !_isSurpriseMeOpen),
                    )
                    ),),
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
                Positioned(
                  top: 350,
                  right: 10,
                  left: 10,
                  bottom: 60,
                  child: Visibility(
                    visible: _isSurpriseMeOpen,
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          IconButton( onPressed: () => setState(() => _isSurpriseMeOpen= false),
                              icon: Icon(Icons.arrow_back, color: defaultColor)),
                          _buildRow('Visited?', valueVisited, itemsVisited),
                          _buildRow('Distance', valueDistance, itemsDistance),
                          _buildRow('Type', valueType, itemsType),
                          _buildRow('Min user rating', valueRatings, itemsRatings),
                          _buildRow('Price range', valuePrice, itemsPrice),
                          /*Container(
                              width: 100,
                              height: 30,
                              padding: EdgeInsets.only(left: 200, top: 0),
                              child: DropdownButton<String>(
                                value: valueVisited,
                                items: itemsVisited.map(buildMenuItem).toList(),
                                onChanged: (value) => setState(() => this.valueVisited= value),
                              )
                          ),*/
                         /* _buildRow('Distance'),
                          Container(
                              width: 20,
                              height: 30,
                              decoration: BoxDecoration(color: Colors.white,
                                borderRadius: BorderRadius.circular(40),

                              ),
                              padding: EdgeInsets.only(left: 200,top: 0),
                              child: DropdownButton<String>(
                                value: valueDistance,
                                items: itemsDistance.map(buildMenuItem).toList(),
                                onChanged: (value) => setState(() => this.valueDistance= value),
                              )
                          ),
                          _buildRow('Type'),
                          Container(
                              width: 20,
                              height: 30,
                              decoration: BoxDecoration(color: Colors.white,
                                borderRadius: BorderRadius.circular(40),

                              ),
                              padding: EdgeInsets.only(left: 200,top: 0),
                              child: DropdownButton<String>(
                                value: valueType,
                                items: itemsType.map(buildMenuItem).toList(),
                                onChanged: (value) => setState(() => this.valueType= value),
                              )
                          ),
                          _buildRow('Min user rating'),
                          Container(
                              width: 20,
                              height: 30,
                              decoration: BoxDecoration(color: Colors.white,
                                borderRadius: BorderRadius.circular(40),

                              ),
                              padding: EdgeInsets.only(left: 200,top: 0),
                              child: DropdownButton<String>(
                                value: valueRatings,
                                items: itemsRatings.map(buildMenuItem).toList(),
                                onChanged: (value) => setState(() => this.valueRatings= value),
                              )
                          ),
                          _buildRow('Price Range'),
                          Container(
                              width: 20,
                              height: 30,
                              decoration: BoxDecoration(color: Colors.white,
                                borderRadius: BorderRadius.circular(40),

                              ),
                              padding: EdgeInsets.only(left: 200,top: 0),
                              child: DropdownButton<String>(
                                value: valuePrice,
                                items: itemsPrice.map(buildMenuItem).toList(),
                                onChanged: (value) => setState(() => this.valuePrice= value),
                              )
                          ),*/
                          SizedBox(height: 12),
                          SizedBox(

                              child: ElevatedButton(
                                child: Text('Surpise!'),
                                style: ElevatedButton.styleFrom(
                                    primary: defaultColor,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {},
                          )
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }


  Widget _buildRow(String name, String? invalue, List<String> items ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: 5),
          Row(
            children: <Widget>[
              SizedBox(width: 12),
              Text(name,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.left,
                style: TextStyle(
                  height: 1.171875,
                  fontSize: 16.0,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 125, 48, 185),),),
              Spacer(),
              Container(
                  height: 30,
                  child: DropdownButton<String>(
                    value: invalue,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 30,
                    underline: SizedBox(),
                    items: items.map(buildItem).toList(),
                    onChanged: (String? newValue) {
                      /*setState(() {
                        invalue = newValue;
                        print(invalue);
                      });*/
                      setState(() {
                        invalue = newValue;
                      });
                    },
                  )
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildRow2(String name ) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Column(
      children: <Widget>[
        SizedBox(height: 5),
        Row(
          children: <Widget>[
            SizedBox(width: 12),
            Text(name,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.left,
              style: TextStyle(
                height: 1.171875,
                fontSize: 16.0,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w700,
                color: Color.fromARGB(255, 125, 48, 185),),),
            Spacer(),
          ],
        ),
      ],
    ),
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
