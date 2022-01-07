import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:where_to_app/screens/welcomeScreen.dart';

import 'locator.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(const WhereToApp());
}

class WhereToApp extends StatelessWidget {
  const WhereToApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'WhereTo App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const WelcomePage()
    );
  }
}
