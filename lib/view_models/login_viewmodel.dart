import 'package:stacked/stacked.dart';
import 'package:where_to_app/services/auth_service.dart';

import '../locator.dart';

class LoginViewModel extends BaseViewModel{
  final AuthService _authService = locator<AuthService>();

  Future<void> signIn() async{
    await _authService.signInWithGoogle();
    if(_authService.userData != null){
      print("Login cu succes");
    }
  }
}