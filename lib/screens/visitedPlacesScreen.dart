import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:where_to_app/constants/constants.dart';

final _firestoreInstance = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;

class VisitedPlacesScreen extends StatelessWidget{
  const VisitedPlacesScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 5.0),
            child: Container(
              child: IconButton( onPressed: () {
                Navigator.pop(context);
              },
                  icon: Icon(Icons.arrow_back, color: defaultColor)
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 60.0),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _firestoreInstance.collection('users').doc(auth.currentUser?.uid).collection('visitedPlaces').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        return ListView(
                        children: snapshot.data!.docs.map((place) {
                          return Center(
                            child: ListTile(
                              title: Text(place['name']),
                              subtitle: Text(place['address']),
                            ),
                          );
    }).toList(),
                        );
                          },
                        )
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}