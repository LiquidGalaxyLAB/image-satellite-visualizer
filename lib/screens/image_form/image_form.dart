import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_satellite_visualizer/models/image_data.dart';
import 'package:image_satellite_visualizer/models/image_request.dart';
import 'package:image_satellite_visualizer/screens/image_form/steps/api_step.dart';
import 'package:image_satellite_visualizer/screens/image_form/steps/data_step.dart';
import 'package:image_satellite_visualizer/screens/image_form/steps/filter_step.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'dart:math';
import 'dart:io';

class ImageForm extends StatefulWidget {
  const ImageForm({Key? key}) : super(key: key);

  @override
  _ImageFormState createState() => _ImageFormState();
}

class _ImageFormState extends State<ImageForm> {
  Box? imageBox;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  int _currentStep = 0;

  Map<String, double> bbox = {};
  late String layer;

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    print('step: $_currentStep');
    _currentStep != 2 ? setState(() => _currentStep += 1) : createRequest();
  }

  cancel() {
    if (_currentStep > 0) setState(() => _currentStep -= 1);
  }

  void createRequest() async {
    var minLat = min(bbox['lat1']!, bbox['lat2']!);
    var maxLat = max(bbox['lat1']!, bbox['lat2']!);
    var minLon = min(bbox['lon1']!, bbox['lon2']!);
    var maxLon = max(bbox['lon1']!, bbox['lon2']!);

    bbox['lat1'] = minLat;
    bbox['lat2'] = maxLat;
    bbox['lon1'] = minLon;
    bbox['lon2'] = maxLon;

    ImageRequest request = new ImageRequest(
      layers: [layer],
      time: '2020-03-30',
      bbox: bbox,
    );

    try {
      showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      var response = await http.get(Uri.parse(request.getRequestUrl()));
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      File file = new File(path.join(documentDirectory.path, 'imagetest.png'));
      file.writeAsBytesSync(response.bodyBytes);

      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (context) {
          Size screenSize = MediaQuery.of(context).size;

          return AlertDialog(
            content: Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Image.file(file, fit: BoxFit.cover),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.01,
                              vertical: screenSize.height * 0.01),
                          child: TextField(
                            controller: _nameController,
                            decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                              hintText: 'Name',
                              labelText: 'Name',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.01,
                              vertical: screenSize.height * 0.01),
                          child: TextField(
                            controller: _descriptionController,
                            maxLines: 11,
                            decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                              hintText: 'Description',
                              labelText: 'Description',
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  createImage(file.path);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Text(
                  'Continue',
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  void createImage(String filePath) {
    imageBox?.add(
      ImageData(
        imagePath: filePath,
        title: _nameController.text,
        description: _descriptionController.text,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    imageBox = Hive.box('imageBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('New Image'),
        leading: BackButton(color: Colors.white),
      ),
      body: Theme(
        data: ThemeData(
          colorScheme:
              ColorScheme.light(primary: Theme.of(context).accentColor),
        ),
        child: Stepper(
          type: StepperType.horizontal,
          physics: ScrollPhysics(),
          currentStep: _currentStep,
          onStepTapped: (step) => tapped(step),
          onStepContinue: continued,
          onStepCancel: cancel,
          steps: <Step>[
            Step(
              title: new Text('API'),
              content: ApiStep(),
              isActive: _currentStep >= 0,
              state:
                  _currentStep >= 0 ? StepState.complete : StepState.disabled,
            ),
            Step(
              title: new Text('Location and date'),
              content: DataStep(callback: this.setCoordinates),
              isActive: _currentStep >= 0,
              state:
                  _currentStep >= 1 ? StepState.complete : StepState.disabled,
            ),
            Step(
              title: new Text('Filters'),
              content: FilterStep(callback: this.setLayer),
              isActive: _currentStep >= 0,
              state:
                  _currentStep >= 2 ? StepState.complete : StepState.disabled,
            ),
          ],
        ),
      ),
    );
  }

  void setCoordinates(Map<String, double> coordinates) {
    setState(() {
      bbox['lat1'] = coordinates['lat1']!;
      bbox['lon1'] = coordinates['lon1']!;
      bbox['lat2'] = coordinates['lat2']!;
      bbox['lon2'] = coordinates['lon2']!;
    });
  }

  void setLayer(String incomingLayer) {
    setState(() {
      layer = incomingLayer;
    });
  }
}
