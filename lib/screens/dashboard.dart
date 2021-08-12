import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:image_satellite_visualizer/screens/image_form/image_form.dart';
import 'package:image_satellite_visualizer/screens/splash_screen.dart';
import 'package:image_satellite_visualizer/widgets/image_card.dart';
import 'package:image_satellite_visualizer/models/image_data.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Box? imageBox;
  Box? settingsBox;

  TextEditingController ipTextController = TextEditingController();
  TextEditingController usernameTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  String searchTextController = "";

  List<ImageData> demoImages = [];

  List<Widget> imageCards(List images) {
    List<Widget> list = [];

    for (ImageData image in images) {
      list.add(
        Container(
          padding: const EdgeInsets.all(8.0),
          child: ImageCard(image: image, callback: setSelection),
        ),
      );
    }
    return list;
  }

  void loadJsonData() async {
    List<ImageData> images = [];
    var jsonText = await rootBundle.loadString('assets/json/demos.json');

    json.decode(jsonText).forEach((element) {
      List<Map<String, String>> colors = [];
      element['colors']
          .forEach((color) => colors.add(Map<String, String>.from(color)));

      images.add(
        ImageData(
          imagePath: element['imagePath'],
          title: element['title'],
          description: element['description'],
          coordinates: Map<String, String>.from(element['coordinates']),
          date: DateTime.parse(element['date']),
          layer: element['layer'],
          layerDescription: element['layerDescription'],
          colors: List<Map<String, String>>.from(colors),
          api: element['api'],
          demo: true,
        ),
      );
    });

    setState(() {
      demoImages = images;
    });
  }

  @override
  void initState() {
    super.initState();
    imageBox = Hive.box('imageBox');
    settingsBox = Hive.box('liquidGalaxySettings');
    loadJsonData();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                onPressed: () => loadJsonData(),
                child: Text(
                  'DEMO',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: screenSize.width * 0.01),
              child: TextButton(
                child: Text(
                  'ABOUT',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SplashScreen(false)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: screenSize.width * 0.01),
              child: TextButton(
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
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenSize.height * 0.015,
                                    horizontal: screenSize.height * 0.015,
                                  ),
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: ipTextController,
                                    decoration: new InputDecoration(
                                      hintText: 'IP',
                                      labelText: 'IP',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenSize.height * 0.015,
                                    horizontal: screenSize.height * 0.015,
                                  ),
                                  child: TextField(
                                    controller: usernameTextController,
                                    decoration: new InputDecoration(
                                      hintText: 'Username',
                                      labelText: 'Username',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenSize.height * 0.015,
                                    horizontal: screenSize.height * 0.015,
                                  ),
                                  child: TextField(
                                    obscureText: true,
                                    controller: passwordTextController,
                                    decoration: new InputDecoration(
                                      hintText: 'Password',
                                      labelText: 'Password',
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
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: Text(
                              "SET",
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                            onPressed: () {
                              settingsBox?.put('ip', ipTextController.text);
                              settingsBox?.put(
                                  'username', usernameTextController.text);
                              settingsBox?.put(
                                  'password', passwordTextController.text);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Icon(Icons.settings, color: Colors.white),
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
                      onChanged: (val) => setState(() {
                        searchTextController = val;
                      }),
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
                        children: imageCards(_runFilter(searchTextController)),
                        childAspectRatio: 0.8,
                        crossAxisSpacing: screenSize.width * 0.03,
                        crossAxisCount: 3,
                        // padding: EdgeInsetsDirectional.all(screenSize.width * 0.07),
                        padding: EdgeInsetsDirectional.fromSTEB(
                          screenSize.width * 0.07,
                          screenSize.height * 0.01,
                          screenSize.width * 0.07,
                          screenSize.height * 0.01,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            GridView.count(
              children: imageCards(demoImages),
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

  void setSelection(ImageData image) {
    setState(() {
      image.selected = !image.selected;
    });
  }

  List<dynamic> _runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = imageBox!.values.toList();
    } else {
      results = imageBox!.values
          .toList()
          .where((image) =>
              image.title.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    return results;
  }
}
