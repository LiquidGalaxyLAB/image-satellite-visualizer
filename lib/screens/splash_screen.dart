import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_satellite_visualizer/screens/dashboard.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  final bool isSplash;
  const SplashScreen(this.isSplash, {Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.isSplash) setTimer();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      child: Center(
                        child: Image.asset(
                          'assets/image_satellite_visualizer_logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      width: screenSize.width / 2,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: Center(
                            child: Image.asset(
                              'assets/pera_logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          width: screenSize.width / 8,
                        ),
                        Container(
                          child: Center(
                            child: Image.asset(
                              'assets/lg_logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          width: screenSize.width / 7,
                        ),
                        Container(
                          child: Center(
                            child: Image.asset(
                              'assets/gsoc.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          width: screenSize.width / 6,
                        ),
                        Container(
                          child: Center(
                            child: Image.asset(
                              'assets/facens.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          width: screenSize.width / 6,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: Center(
                            child: Image.asset(
                              'assets/lg_lab_logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          width: screenSize.width / 6,
                        ),
                        Container(
                          child: Center(
                            child: Image.asset(
                              'assets/lg_eu_logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          width: screenSize.width / 6,
                        ),
                        Container(
                          child: Center(
                            child: Image.asset(
                              'assets/pcital.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          width: screenSize.width / 6,
                        ),
                        Container(
                          child: Center(
                            child: Image.asset(
                              'assets/tic_logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          width: screenSize.width / 7,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            widget.isSplash
                ? Container()
                : SafeArea(
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
            widget.isSplash
                ? Container()
                : SafeArea(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              const url = 'https://github.com/LiquidGalaxyLAB/image-satellite-visualizer';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.all(screenSize.width * 0.01),
                              child: Container(
                                width: screenSize.width * 0.03,
                                height: screenSize.width * 0.03,
                                child: Image.asset('assets/github_logo.png'),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              const url = 'https://www.liquidgalaxy.eu/';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.all(screenSize.width * 0.01),
                              child: Container(
                                width: screenSize.width * 0.04,
                                height: screenSize.width * 0.04,
                                child: Image.asset('assets/lg_logo.png'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  setTimer() async {
    Duration duration = Duration(seconds: 5);

    return Timer(duration, finishSplashScreen);
  }

  finishSplashScreen() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Dashboard(title: 'Image Satellite Visualizer')));
  }
}
