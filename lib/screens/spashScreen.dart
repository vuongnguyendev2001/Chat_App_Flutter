import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase/screens/chathomepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

String? finalEmail;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String id = 'splash_screen';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    getValidationDate().whenComplete(() async {});
    super.initState();
  }

  Future getValidationDate() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var get = sharedPreferences.getString('email');
    setState(() {
      finalEmail = get;
    });
    print(finalEmail);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splashIconSize: 2500,
      splash: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                  'https://png.pngtree.com/background/20210715/original/pngtree-original-font-handheld-mobile-phone-chat-background-picture-image_1305279.jpg',
                ),
                fit: BoxFit.cover,
                colorFilter:
                    ColorFilter.mode(Colors.black38, BlendMode.darken))),
        child: Container(
          margin: EdgeInsets.only(top: 200, left: 20, right: 20, bottom: 70),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: SpinKitFadingCircle(
                      size: 60,
                      itemBuilder: (_, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: index.isEven ? Colors.white : Colors.purple,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      duration: 2000,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.rightToLeftWithFade,
      nextScreen: finalEmail == null ? Login() : chatHomePage(),
      // nextScreen: Login(),
    );
  }
}
