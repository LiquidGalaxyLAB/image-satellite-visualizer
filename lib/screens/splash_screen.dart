import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_satellite_visualizer/screens/dashboard.dart';

// List of images
final List<String> images = [
  'assets/gsoc.png',
  'assets/lg_logo.png',
  'assets/image_satellite_visualizer_logo.png',
  'assets/lg_lab_logo.png',
  'assets/lg_eu_logo.png',
  'assets/pcital.png'
];

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
    if(widget.isSplash) setTimer();
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.05),
                          child: Container(
                            child: Center(
                              child: Image.asset(
                                'assets/lg_logo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            width: screenSize.width / 7,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.05),
                          child: Container(
                            child: Center(
                              child: Image.asset(
                                'assets/gsoc.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            width: screenSize.width / 5,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.05),
                          child: Container(
                            child: Center(
                              child: Image.asset(
                                'assets/facens.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            width: screenSize.width / 7,
                          ),
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
        context, MaterialPageRoute(builder: (context) => Dashboard(title: 'Image Satellite Visualizer')));
  }
}