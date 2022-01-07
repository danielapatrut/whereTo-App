import 'package:get_it/get_it.dart';
import 'package:where_to_app/services/auth_service.dart';

GetIt locator = GetIt.instance;

void setupLocator(){
  locator.registerLazySingleton(() => AuthService());
}