import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_satellite_visualizer/models/client.dart';
import 'package:image_satellite_visualizer/models/image_data.dart';

class ImageCard extends StatefulWidget {
  const ImageCard({Key? key, required this.image}) : super(key: key);
  final ImageData image;

  @override
  _ImageCardState createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  Box? settingsBox;

  @override
  void initState() {
    super.initState();
    settingsBox = Hive.box('liquidGalaxySettings');
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      width: screenSize.width * 0.22,
      height: screenSize.height * 0.5,
      child: Card(
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child: Container(
                child: Image.file(
                  File(widget.image.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(screenSize.width * 0.01),
                child: Text(
                  widget.image.title,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: screenSize.width * 0.015,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: screenSize.width * 0.01),
                child: Text(
                  widget.image.description,
                  style: TextStyle(fontWeight: FontWeight.w300),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
            ),
            Spacer(),
            Expanded(
              flex: 2,
              child: Container(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Delete"),
                              content: Text(
                                  "Are you sure that you want to delete this image?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    widget.image.delete();
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.delete),
                    ),
                    IconButton(
                      onPressed: () => print('EDIT'),
                      icon: Icon(Icons.edit),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        Client client = Client(
                          ip: settingsBox?.get('ip'),
                          username: settingsBox?.get('username'),
                          password: settingsBox?.get('password'),
                          image: widget.image,
                        );
                        try {
                          client.createClient();
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Error sending image"),
                                content: Text(
                                  e.toString(),
                                ),
                              );
                            },
                          );
                        }
                      },
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).accentColor,
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
}
