import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:where_to_app/models/user.dart';

class AuthService {
  UserData? userData;

  Future<void> signInWithGoogle() async {
    UserCredential? userCredential;
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken
    );

    try{
      userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      userData = UserData(
        uid: userCredential.user?.uid,
        name: userCredential.user?.displayName,
        email: userCredential.user?.email,
      );
    } catch(e) {
      print(e.toString());
    }
  }
}