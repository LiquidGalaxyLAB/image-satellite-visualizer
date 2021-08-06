import 'package:flutter/material.dart';

class LayerInfo extends StatelessWidget {
  final Map<String, dynamic> layerData;
  const LayerInfo(this.layerData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return AlertDialog(
      content: Container(
        width: screenSize.width * 0.8,
        height: screenSize.height * 0.65,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: screenSize.width * 0.4,
                  child: Text(
                    "Image",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontSize: screenSize.height * 0.035),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: screenSize.height * 0.03,
                    left: screenSize.width * 0.015,
                  ),
                  child: Container(
                    height: screenSize.height * 0.35,
                    width: screenSize.width * 0.35,
                    child: Image.asset(
                      layerData['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: screenSize.height * 0.03,
                    left: screenSize.width * 0.015,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(layerData['colors'].length, (index) {
                      return Padding(
                        padding:
                            EdgeInsets.only(bottom: screenSize.height * 0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              height: screenSize.height * 0.02,
                              width: screenSize.height * 0.02,
                              color: getColor(
                                  layerData['colors'][index]['value']!),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: screenSize.width * 0.015,
                              ),
                              child: Text(
                                layerData['colors'][index]['description']!,
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: screenSize.width * 0.4,
                  child: Text(
                    layerData['name'],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(fontSize: screenSize.height * 0.035),
                  ),
                ),
                Container(
                  width: screenSize.width * 0.4,
                  height: screenSize.height * 0.5,
                  child: Padding(
                    padding: EdgeInsets.only(left: screenSize.width * 0.015),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: screenSize.height * 0.05),
                        child: Text(
                          layerData['description'],
                          style: TextStyle(fontSize: screenSize.width * 0.015),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color getColor(String color) {
    var _color = Colors.white;
    switch (color) {
      case "red":
        {
          _color = Colors.red;
        }
        break;

      case "blue":
        {
          _color = Colors.blue;
        }
        break;

      case "green":
        {
          _color = Colors.green;
        }
        break;

      case "grey":
        {
          _color = Colors.grey;
        }
        break;

      case "brown":
        {
          _color = Colors.brown;
        }
        break;

      case "white":
        {
          _color = Colors.white;
        }
        break;

      case "black":
        {
          _color = Colors.black;
        }
        break;

      default:
        {
          _color = Colors.yellow;
        }
        break;
    }
    return _color;
  }
}
