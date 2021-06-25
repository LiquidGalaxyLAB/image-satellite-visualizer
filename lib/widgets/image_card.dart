import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_satellite_visualizer/models/image_data.dart';

class ImageCard extends StatefulWidget {
  const ImageCard({Key? key, required this.image}) : super(key: key);
  final ImageData image;

  @override
  _ImageCardState createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  Box? imageBox;

  @override
  void initState() {
    super.initState();
    imageBox = Hive.box('imageBox');
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
          children: [
            Expanded(
              flex: 7,
              child: Container(
                child: Image.network(widget.image.imagePath, fit: BoxFit.cover),
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
            Expanded(
              flex: 2,
              child: Container(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => widget.image.delete(),
                      icon: Icon(Icons.delete),
                    ),
                    IconButton(
                      onPressed: () => print('EDIT'),
                      icon: Icon(Icons.edit),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () => print('SEND'),
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
