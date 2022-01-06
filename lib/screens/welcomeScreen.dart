import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:where_to_app/constants/constants.dart';

class WelcomePage extends StatelessWidget{
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.2),
            Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                  "Welcome!",
                  style: GoogleFonts.beVietnam(
                    textStyle: const TextStyle(
                        color: Color.fromRGBO(126, 49, 186, 1.0),
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                    ),
                  )
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Text(
                "Please use your Google account to log in.",
                style: GoogleFonts.beVietnam(
                    textStyle: TextStyle(
                        color: defaultColor,
                        fontSize: 14
                    )
                )
            ),
            SizedBox(height: size.height * 0.2),
            TextButton.icon(
                icon: SvgPicture.asset(
                  "assets/icons8-google.svg",
                  height: 40.0,
                ),
                label: Text(
                  "Log in with Google",
                  style: TextStyle(
                    color: googleTextColor,
                    fontSize: 18,
                  ),
                ),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)
                  ),
                  alignment: Alignment.centerLeft,
                  backgroundColor: Colors.white,
                  shadowColor: Colors.grey,
                  fixedSize: Size(
                      MediaQuery.of(context).size.width * 0.9,
                      50.0
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  elevation: 3.0,
                  //side: BorderSide()
                ),
                onPressed: () => null
            )
          ]
      ),
    );
  }
}