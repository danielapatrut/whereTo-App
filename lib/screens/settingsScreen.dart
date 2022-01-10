
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:where_to_app/constants/constants.dart';
import 'package:where_to_app/screens/visitedPlacesScreen.dart';

final _firestoreInstance = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  createDialog(BuildContext context)
  {
    return showDialog(context: context,
        builder: (context){
          return SimpleDialog(
            title: Text('Select preffered distance'),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                child: Text('200 m'),
                onPressed: () {
                  setDistanceValue(200);
                  Navigator.pop(context);
                },),
              SimpleDialogOption(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                child: Text('500 m'),
                onPressed: () {
                  setDistanceValue(500);
                  Navigator.pop(context);
             },),
              SimpleDialogOption(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                child: Text('1000 m'),
                onPressed: () {
                  setDistanceValue(1000);
                  Navigator.pop(context);
                },),
              SimpleDialogOption(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                child: Text('1500 m'),
                onPressed: () {
                  setDistanceValue(1500);
                  Navigator.pop(context);
                },),
            ],
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 5.0),
            child: Row(
              children: [
                Container(
                  child: IconButton( onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back, color: defaultColor)
                  ),
                ),
              ],
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
                    child: ListView(
                      children: [
                        Card(
                          child: ListTile(
                              title: Text('Visited Places', style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,

                              ),),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: googleTextColor!.withOpacity(0.2),
                                width: 0.5
                              ),
                            ),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => VisitedPlacesScreen()));
                            },
                          ),
                        ),
                        Card(
                          child: ListTile(
                            title: Text('Default distance', style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,

                            ),),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: googleTextColor!.withOpacity(0.2),
                                width: 0.5
                              ),
                            ),
                            onTap: ()
                            {
                              createDialog(context);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );

  }

  void setDistanceValue(num i) {
    _firestoreInstance.collection('users').doc(auth.currentUser?.uid)
        .set(
        {
          'name': auth.currentUser?.displayName,
          'preferedDistance': i,
        });

  }

}