import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_satellite_visualizer/models/image_data.dart';
import 'package:image_satellite_visualizer/models/image_request.dart';
import 'package:image_satellite_visualizer/screens/image_form/steps/api_step.dart';
import 'package:image_satellite_visualizer/screens/image_form/steps/data_step.dart';
import 'package:image_satellite_visualizer/screens/image_form/steps/final_step.dart';
import 'package:image_satellite_visualizer/screens/image_form/steps/layer_step.dart';
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

  int _currentStep = 0;

  String selectedApi = "Nasa";
  Map<String, TextEditingController> coordinates = {
    "lat1Controller": TextEditingController(),
    "lon1Controller": TextEditingController(),
    "lat2Controller": TextEditingController(),
    "lon2Controller": TextEditingController(),
  };
  DateTime date = DateTime.now();
  String layer =
      "MODIS_Terra_CorrectedReflectance_TrueColor"; //TODO: Add map for base and ovelay layers
  String? imagePath;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void createRequest() async {
    var minLat = min(double.parse(coordinates['lat1Controller']!.text),
        double.parse(coordinates['lat2Controller']!.text));
    var maxLat = max(double.parse(coordinates['lat1Controller']!.text),
        double.parse(coordinates['lat2Controller']!.text));
    var minLon = min(double.parse(coordinates['lon1Controller']!.text),
        double.parse(coordinates['lon2Controller']!.text));
    var maxLon = max(double.parse(coordinates['lon1Controller']!.text),
        double.parse(coordinates['lon2Controller']!.text));

    Map<String, dynamic> bbox = {
      'lat1': minLat,
      'lat2': maxLat,
      'lon1': minLon,
      'lon2': maxLon,
    };

    ImageRequest request = new ImageRequest(
      layers: [layer],
      time: '2020-03-30',
      bbox: bbox,
    );

    var response = await http.get(Uri.parse(request.getRequestUrl()));
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    File file = new File(path.join(documentDirectory.path,
        '${DateTime.now().millisecondsSinceEpoch}.png'));
    file.writeAsBytesSync(response.bodyBytes);

    print('imagePath: ${file.path}');

    setState(() {
      imagePath = file.path;
    });
  }

  void createImage() {
    imageBox?.add(
      ImageData(
        imagePath: imagePath!,
        title: nameController.text,
        description: descriptionController.text,
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
              content: ApiStep(selectedApi, setApi),
              isActive: _currentStep >= 0,
              state:
                  _currentStep >= 0 ? StepState.complete : StepState.disabled,
            ),
            Step(
              title: new Text('Location and date'),
              content: DataStep(
                  textControllers: coordinates,
                  date: date,
                  coordinateCallback: setCoordinates,
                  dateCallback: setDate),
              isActive: _currentStep >= 0,
              state:
                  _currentStep >= 1 ? StepState.complete : StepState.disabled,
            ),
            Step(
              title: new Text('Layers'),
              content: FilterStep(layer, setLayer),
              isActive: _currentStep >= 0,
              state:
                  _currentStep >= 2 ? StepState.complete : StepState.disabled,
            ),
            Step(
              title: new Text('Final'),
              content:
                  FinalStep(nameController, descriptionController, imagePath),
              isActive: _currentStep >= 0,
              state:
                  _currentStep >= 3 ? StepState.complete : StepState.disabled,
            ),
          ],
        ),
      ),
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    if (_currentStep < 3) {
      setState(() => _currentStep += 1);
      if (_currentStep == 3) {
        createRequest();
      }
    } else {
      createImage();
      Navigator.pop(context);
    }
  }

  cancel() {
    if (_currentStep > 0) setState(() => _currentStep -= 1);
  }

  void setApi(String api) {
    setState(() {
      selectedApi = api;
    });
  }

  void setCoordinates(Map<MarkerId, Marker> markers) {
    setState(() {
      coordinates['lat1Controller']?.text =
          markers.values.elementAt(0).position.latitude.toString();
      coordinates['lon1Controller']?.text =
          markers.values.elementAt(0).position.longitude.toString();
      coordinates['lat2Controller']?.text =
          markers.values.elementAt(1).position.latitude.toString();
      coordinates['lon2Controller']?.text =
          markers.values.elementAt(1).position.longitude.toString();
    });
  }

  void setDate(DateTime newDate) {
    setState(() {
      date = newDate;
    });
  }

  void setLayer(String incomingLayer) {
    setState(() {
      layer = incomingLayer;
    });
  }
}
