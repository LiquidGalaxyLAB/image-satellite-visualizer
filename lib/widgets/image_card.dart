import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_satellite_visualizer/models/client.dart';
import 'package:image_satellite_visualizer/models/image_data.dart';
import 'package:image_satellite_visualizer/widgets/image_info.dart'
    as imageInfo;

class ImageCard extends StatefulWidget {
  const ImageCard({
    Key? key,
    required this.image,
    required this.callback,
  }) : super(key: key);
  final ImageData image;
  final callback;

  @override
  _ImageCardState createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  Box? settingsBox;
  Box? selectedImagesBox;

  TextEditingController titleEditingController = TextEditingController();
  TextEditingController descriptionEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    settingsBox = Hive.box('liquidGalaxySettings');
    selectedImagesBox = Hive.box('selectedImages');
    titleEditingController.text = widget.image.title;
    descriptionEditingController.text = widget.image.description;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      child: Card(
        elevation: 3,
        child: InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return imageInfo.ImageInfo(widget.image);
                });
          },
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 10,
                  child: Container(
                    child: widget.image.demo
                        ? Image.asset(
                            widget.image.imagePath,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(widget.image.imagePath),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(
                      left: screenSize.width * 0.01,
                      right: screenSize.width * 0.01,
                      top: screenSize.width * 0.01,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: screenSize.width * 0.15,
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
                        Text(
                          '${widget.image.date.year}/${widget.image.date.month}/${widget.image.date.day}',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(right: screenSize.width * 0.01),
                          child: Chip(
                            label: Text(
                              widget.image.api,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: screenSize.width * 0.009,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsets.only(right: screenSize.width * 0.01),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Flexible(
                                  child: Chip(
                                    label: Text(
                                      widget.image.layer,
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: screenSize.width * 0.009,
                                      ),
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
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: screenSize.width * 0.01,
                      right: screenSize.width * 0.01,
                      top: screenSize.width * 0.008,
                    ),
                    child: Text(
                      widget.image.description,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: screenSize.width * 0.0125,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Row(
                      children: [
                        widget.image.demo
                            ? Container()
                            : IconButton(
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
                                            onPressed: () async {
                                              widget.image.delete();
                                              await selectedImagesBox?.delete(
                                                  'http://lg1:81/${widget.image.getFileName()}.kml');

                                              Client client = Client(
                                                ip: settingsBox?.get('ip'),
                                                username: settingsBox
                                                    ?.get('username'),
                                                password: settingsBox
                                                    ?.get('password'),
                                                image: widget.image,
                                              );

                                              try {
                                                client.deleteImages(
                                                    widget.image.getFileName(),
                                                    selectedImagesBox!.values
                                                        .toList()
                                                        .join('\n'));
                                              } catch (e) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          "Error deleting image"),
                                                      content: Text(
                                                        e.toString(),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Delete",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text(
                                              "Cancel",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.delete),
                              ),
                        widget.image.demo
                            ? Container()
                            : IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: SingleChildScrollView(
                                            child: Container(
                                              width: screenSize.width * 0.6,
                                              height: screenSize.height * 0.5,
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical:
                                                          screenSize.height *
                                                              0.015,
                                                      horizontal:
                                                          screenSize.height *
                                                              0.015,
                                                    ),
                                                    child: TextField(
                                                      controller:
                                                          titleEditingController,
                                                      decoration:
                                                          new InputDecoration(
                                                        hintText: 'Title',
                                                        labelText: 'Title',
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical:
                                                          screenSize.height *
                                                              0.015,
                                                      horizontal:
                                                          screenSize.height *
                                                              0.015,
                                                    ),
                                                    child: TextField(
                                                      maxLines: 8,
                                                      controller:
                                                          descriptionEditingController,
                                                      decoration:
                                                          new InputDecoration(
                                                        hintText: 'Description',
                                                        labelText:
                                                            'Description',
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              child: Text(
                                                "CANCEL",
                                                style: TextStyle(
                                                    color: Colors.grey[600]),
                                              ),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                            TextButton(
                                              child: Text(
                                                "SET",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .accentColor),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  widget.image.title =
                                                      titleEditingController
                                                          .text;
                                                  widget.image.description =
                                                      descriptionEditingController
                                                          .text;
                                                });
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                },
                                icon: Icon(Icons.edit),
                              ),
                        Spacer(),
                        IconButton(
                          onPressed: () async {
                            widget.callback(widget.image);
                            widget.image.selected
                                ? await selectedImagesBox?.put(
                                    'http://lg1:81/${widget.image.getFileName()}.kml',
                                    'http://lg1:81/${widget.image.getFileName()}.kml')
                                : await selectedImagesBox?.delete(
                                    'http://lg1:81/${widget.image.getFileName()}.kml');

                            Client client = Client(
                              ip: settingsBox?.get('ip'),
                              username: settingsBox?.get('username'),
                              password: settingsBox?.get('password'),
                              image: widget.image,
                            );
                            try {
                              client.sendImage(selectedImagesBox!.values
                                  .toList()
                                  .join('\n'));
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
                            widget.image.selected
                                ? Icons.remove_circle
                                : Icons.send,
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
        ),
      ),
    );
  }
}
