import 'package:flutter/material.dart';
import 'package:image_satellite_visualizer/models/image_data.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({Key? key, required this.image}) : super(key: key);
  final ImageData image;

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
                child: Image.network(image.imagePath, fit: BoxFit.cover),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(screenSize.width * 0.01),
                child: Text(
                  image.title,
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
                  image.description,
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
                        onPressed: () => print('DELETE'), icon: Icon(Icons.delete)),
                    IconButton(
                      onPressed: () => print('EDIT'),
                      icon: Icon(Icons.edit),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () => print('SEND'),
                      icon: Icon(Icons.send,
                          color: Theme.of(context).accentColor),
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
