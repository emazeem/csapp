import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connect_social/view/screens/widgets/layout.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen();

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? timer;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      timer = Timer.periodic(
          Duration(milliseconds: 500), (Timer t) => animateIcon());
    });
    super.initState();

    new Future.delayed(
        const Duration(seconds: 3),
        () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => NPLayout()),
              (Route<dynamic> route) => false,
            ));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  double widthOfLogo = 120.0;
  animateIcon() {
    if (widthOfLogo == 120.0) {
      widthOfLogo = 200.0;
    } else {
      widthOfLogo = 120.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomLeft,
                      stops: [
                        0.1,
                        0.4,
                        0.6,
                        0.9,
                      ],
                      colors: [
                        Color(0xFFf0f2f5),
                        Color(0xFFf0f2f5),
                        Color(0xFFf0f2f5),
                        Colors.white,
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedContainer(
                                width: widthOfLogo,
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  width: 160,
                                  height: 160,
                                ),
                                duration: Duration(seconds: 1),
                                curve: Curves.easeInOutCirc,
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 40),
                                child: DefaultTextStyle(
                                  style: GoogleFonts.robotoSlab(
                                      fontSize: 25,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey),
                                  child: AnimatedTextKit(
                                    animatedTexts: [
                                      TypewriterAnimatedText(
                                        'Welcome to Connect Social',
                                        speed:
                                            const Duration(milliseconds: 100),
                                      ),
                                    ],
                                    totalRepeatCount: 100,
                                    displayFullTextOnTap: true,
                                    stopPauseOnTap: false,
                                  ),
                                ),
                              ),
                            ],
                          )),
                        ),
                      ),
                      /*FutureBuilder(
                          future: Constants.authNavigation(context),
                          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.hasData) {
                              String routeToScreen=snapshot.data;
                              switch (routeToScreen){
                                case 'home':
                                  if(user?.email_verified_at == null){
                                    Future.delayed(Duration.zero, () {
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AccountVerificationScreen()));
                                    });
                                    break;
                                  }else if(user?.email_verified_at != null){
                                    Future.delayed(Duration.zero, () {
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NPLayout()));
                                    });
                                    break;
                                  }
                                  break;
                                case 'login':
                                  Future.delayed(Duration.zero, () {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                  });
                                  break;
                              }
                              return Container();
                            }
                            return Container();
                          }

                      )
                      */
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
