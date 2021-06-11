import 'package:flutter/material.dart';
import 'package:image_satellite_visualizer/widget/image_card.dart';
import 'package:image_satellite_visualizer/model/image_data.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<ImageData> images = [
    ImageData(
      imagePath:
          "https://www.zerogravity.fi/wp-content/uploads/2019/11/satellite-data-e1572891876593-621x556.jpg",
      title: "Teste 1",
      description:
          "Lorem ipsum dolor sdit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    ),
    ImageData(
      imagePath:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFxW15fFpCC2BbqBM_aN00KFB9cPYFmm0VEQ&usqp=CAU",
      title: "Teste 2",
      description:
          "Lorem ipsum dolor sdit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    ),
    ImageData(
      imagePath:
          "https://miro.medium.com/max/6300/1*BzaxmZjEVpTFtKJeex_ayg.jpeg",
      title: "Teste 3",
      description:
          "Lorem ipsum dolor sdit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    ),
    ImageData(
      imagePath:
          "https://media.wired.com/photos/5e8e2ed8ca6a5100098746d1/16:9/w_2287,h_1286,c_limit/Science_satellitecovid_01_golden-gate-bridge-and-chrissy-park_san-francisco_california_3march2020_.jpg",
      title: "Teste 4",
      description:
          "Lorem ipsum dolor sdit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    ),
  ];

  List<Widget> imageCards() {
    List<Widget> list = [];
    for (ImageData image in images) {
      list.add(
        Container(
          padding: const EdgeInsets.all(8.0),
          child: ImageCard(image: image),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
            padding: EdgeInsets.only(left: screenSize.width * 0.01),
            child: TextButton(
              onPressed: () => print('DEMO'),
              child: Text(
                'DEMO',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: screenSize.width * 0.01),
            child: TextButton(
              onPressed: () => print('LIQUID GALAXY'),
              child: Icon(Icons.wifi, color: Colors.white),
            ),
          ),
        ],
      ),
      body: GridView.count(
        children: imageCards(),
        childAspectRatio: 0.8,
        crossAxisSpacing: screenSize.width * 0.03,
        crossAxisCount: 3,
        padding: EdgeInsetsDirectional.all(screenSize.width * 0.07),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => print('FAB'),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
