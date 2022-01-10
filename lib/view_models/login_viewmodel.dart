import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked/stacked.dart';
import 'package:where_to_app/services/auth_service.dart';

import '../locator.dart';

class LoginViewModel extends BaseViewModel{
  final AuthService _authService = locator<AuthService>();

  Future<void> signIn() async{
    await _authService.signInWithGoogle();
    final _firestoreInstance = FirebaseFirestore.instance;
    if(_authService.userData != null){
      print("Login cu succes");
      final snapShot = await _firestoreInstance
          .collection('users')
          .doc(_authService.userData?.uid) // varuId in your case
          .get();

      if (snapShot == null || !snapShot.exists) {
        // Document with id == varuId doesn't exist.
        _firestoreInstance.collection('users').doc(_authService.userData?.uid).set(
            {
              'name' : _authService.userData?.name,
              'preferedDistance': 1500
            }
        );
        // You can add data to Firebase Firestore here
      }

    }

  }
}