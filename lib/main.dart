import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:where_to_app/controllerLogin.dart';
import 'package:where_to_app/screens/loginScreen.dart';
import 'package:where_to_app/screens/welcomeScreen.dart';
/*
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ControllerLogin() )
      ],
      child: MaterialApp(
        title: 'WhereTo-App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),
      )
      );
  }
}
*/
void main() {
  runApp(const WhereToApp());
}

class WhereToApp extends StatelessWidget {
  const WhereToApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const WelcomePage()
    );
  }
}


