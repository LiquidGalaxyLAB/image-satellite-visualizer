import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      width: 300,
      height: 450,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
                'https://www.zerogravity.fi/wp-content/uploads/2019/11/satellite-data-e1572891876593-621x556.jpg'),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenSize.height * 0.02,
                horizontal: screenSize.width * 0.01,
              ),
              child: Text(
                'Title',
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: screenSize.width * 0.015),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.01,
              ),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                style: TextStyle(fontWeight: FontWeight.w300),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenSize.height * 0.02,
                horizontal: screenSize.width * 0.01,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => print('cu'),
                    icon: Icon(Icons.delete)
                  ),
                  IconButton(
                    onPressed: () => print('cu'),
                    icon: Icon(Icons.edit),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => print('cu'),
                    icon: Icon(Icons.send, color: Theme.of(context).accentColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
