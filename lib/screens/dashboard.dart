import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:image_satellite_visualizer/models/image_request.dart';
import 'package:image_satellite_visualizer/screens/image_form/image_form.dart';
import 'package:image_satellite_visualizer/widgets/image_card.dart';
import 'package:image_satellite_visualizer/models/image_data.dart';
import 'package:image_satellite_visualizer/widgets/image_card_demo.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Box? imageBox;

  List<Widget> imageCards(bool demo, List images) {
    List<Widget> list = [];
    for (ImageData image in images) {
      list.add(
        Container(
          padding: const EdgeInsets.all(8.0),
          child: demo ? ImageCardDemo(image: image) : ImageCard(image: image),
        ),
      );
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    imageBox = Hive.box('imageBox');
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Image Satellite Visualizer'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'My Images'),
              Tab(text: 'Demo'),
            ],
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(left: screenSize.width * 0.01),
              child: TextButton(
                onPressed: () async {
                  ImageRequest request = ImageRequest(
                    layers: [''],
                    time: 'time',
                    bbox: {
                      'lat1': -23.683348,
                      'long1': -45.264316,
                      'lat2': -22.290165,
                      'long2': 43.414857,
                    },
                  );
                  print(request.calculateDistance(request.bbox['lat1'], request.bbox['long1'], request.bbox['lat2'], request.bbox['long2']));
                  // imageBox!.add(
                  //   ImageData(
                  //     imagePath:
                  //         "https://wvs.earthdata.nasa.gov/api/v1/snapshot?REQUEST=GetSnapshot&LAYERS=MODIS_Terra_CorrectedReflectance_Bands721,MODIS_Terra_Thermal_Anomalies_Day&CRS=EPSG:4326&TIME=2015-06-18&WRAP=DAY,DAY&BBOX=-7.912045,-67.937737,-3.294353,-56.612034&FORMAT=image/jpeg&WIDTH=5154&HEIGHT=2102&AUTOSCALE=TRUE&ts=1625108987976",
                  //     title: "Teste",
                  //     description:
                  //         "Lorem ipsum dolor sdit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                  //   ),
                  // );
                },
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
        body: TabBarView(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      screenSize.width * 0.1,
                      screenSize.height * 0.04,
                      screenSize.width * 0.1,
                      screenSize.height * 0.01,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        labelText: 'Search',
                      ),
                    ),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: Hive.box('imageBox').listenable(),
                  builder: (context, box, widget) {
                    return Expanded(
                      flex: 8,
                      child: GridView.count(
                        children: imageCards(false, imageBox!.values.toList()),
                        childAspectRatio: 0.8,
                        crossAxisSpacing: screenSize.width * 0.03,
                        crossAxisCount: 3,
                        // padding: EdgeInsetsDirectional.all(screenSize.width * 0.07),
                        padding: EdgeInsetsDirectional.fromSTEB(
                            screenSize.width * 0.07,
                            screenSize.height * 0.01,
                            screenSize.width * 0.07,
                            screenSize.height * 0.01),
                      ),
                    );
                  },
                ),
              ],
            ),
            ValueListenableBuilder(
              valueListenable: Hive.box('imageBox').listenable(),
              builder: (context, box, widget) {
                return ListView(
                  children: imageCards(true, imageBox!.values.toList()),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ImageForm()),
          ),
          tooltip: 'New image',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
