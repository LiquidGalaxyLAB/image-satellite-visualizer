import 'package:flutter/material.dart';

class ApiStep extends StatefulWidget {
  const ApiStep({
    Key? key,
  }) : super(key: key);

  @override
  _ApiStepState createState() => _ApiStepState();
}

class _ApiStepState extends State<ApiStep> {
  late String selected;
  
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: screenSize.height * 0.06),
      height: screenSize.height * 0.65,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                selected = 'Copernicus';
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    width: 300,
                    height: 300,
                    child: Image.asset(
                      'assets/images/copernicus.png',
                      fit: BoxFit.contain,
                      width: 100,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    width: 250,
                    height: 400,
                    child: Text(
                      'Lorem ipsum dolor sdit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                selected = 'NASA';
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.05),
                    width: 300,
                    height: 300,
                    child: Image.asset(
                      'assets/images/nasa.png',
                      fit: BoxFit.contain,
                      width: 100,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    width: 250,
                    height: 400,
                    child: Text(
                      'Lorem ipsum dolor sdit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                selected = 'SentinelHub';
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    width: 300,
                    height: 300,
                    child: Image.asset(
                      'assets/images/sentinelhub.png',
                      fit: BoxFit.contain,
                      width: 100,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    width: 250,
                    height: 400,
                    child: Text(
                      'Lorem ipsum dolor sdit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
