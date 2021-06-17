import 'package:flutter/material.dart';
import 'package:image_satellite_visualizer/models/image_data.dart';

class ImageCardDemo extends StatelessWidget {
  const ImageCardDemo({Key? key, required this.image}) : super(key: key);
  final ImageData image;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      width: screenSize.width * 0.8,
      height: screenSize.height * 0.3,
      child: Card(
        elevation: 3,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                child: Image.network(image.imagePath, fit: BoxFit.cover),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                padding: EdgeInsets.all(screenSize.width * 0.02),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(bottom: screenSize.height * 0.01),
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
                    Text(
                      image.description,
                      style: TextStyle(fontWeight: FontWeight.w300),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Spacer(),
                        IconButton(
                          onPressed: () => print('SEND'),
                          icon: Icon(Icons.send,
                              color: Theme.of(context).accentColor),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            // Expanded(
            //   flex: 2,
            //   child: Container(
            //     child: Row(
            //       children: [
            //         IconButton(
            //             onPressed: () => print('DELETE'),
            //             icon: Icon(Icons.delete)),
            //         IconButton(
            //           onPressed: () => print('EDIT'),
            //           icon: Icon(Icons.edit),
            //         ),
            //         Spacer(),
            //         IconButton(
            //           onPressed: () => print('SEND'),
            //           icon: Icon(Icons.send,
            //               color: Theme.of(context).accentColor),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
