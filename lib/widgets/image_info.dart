import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_satellite_visualizer/models/image_data.dart';

class ImageInfo extends StatelessWidget {
  final ImageData image;
  const ImageInfo(this.image, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return AlertDialog(
      content: Container(
        width: screenSize.width * 0.8,
        height: screenSize.height * 0.8,
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
                    style: TextStyle(fontSize: screenSize.height * 0.05),
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
                    child: image.demo
                        ? Image.asset(
                            image.imagePath,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(image.imagePath),
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
                    children: List.generate(image.colors.length, (index) {
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
                              color: getColor(image.colors[index]['value']!),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: screenSize.width * 0.015,
                              ),
                              child: Text(
                                image.colors[index]['description']!,
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
                    image.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontSize: screenSize.height * 0.05),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: screenSize.height * 0.01,
                      horizontal: screenSize.width * 0.015),
                  child: Row(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(right: screenSize.width * 0.01),
                        child: Chip(
                          label: Text(image.api),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(right: screenSize.width * 0.01),
                        child: Chip(
                          label: Text(
                            image.layer,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: screenSize.width * 0.4,
                  height: screenSize.height * 0.63,
                  child: Padding(
                    padding: EdgeInsets.only(left: screenSize.width * 0.015),
                    child: DefaultTabController(
                      length: 2,
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        appBar: PreferredSize(
                          preferredSize: Size.fromHeight(kToolbarHeight),
                          child: Container(
                            color: Colors.transparent,
                            child: SafeArea(
                              child: Column(
                                children: <Widget>[
                                  Expanded(child: Container()),
                                  TabBar(
                                    tabs: [
                                      Tab(
                                        child: Text(
                                          "Description",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      ),
                                      Tab(
                                        child: Text(
                                          "Layer",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        body: TabBarView(
                          children: [
                            SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: screenSize.height * 0.015),
                                child: Text(
                                  image.description,
                                  style: TextStyle(
                                      fontSize: screenSize.width * 0.015),
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: screenSize.height * 0.015),
                                child: Text(
                                  image.layerDescription,
                                  style: TextStyle(
                                      fontSize: screenSize.width * 0.015),
                                ),
                              ),
                            ),
                          ],
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
