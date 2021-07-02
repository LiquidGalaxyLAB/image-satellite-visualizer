import 'package:flutter/material.dart';
import 'package:image_satellite_visualizer/screens/image_form/steps/api_step.dart';
import 'package:image_satellite_visualizer/screens/image_form/steps/data_step.dart';
import 'package:image_satellite_visualizer/screens/image_form/steps/filter_step.dart';

class ImageForm extends StatefulWidget {
  const ImageForm({Key? key}) : super(key: key);

  @override
  _ImageFormState createState() => _ImageFormState();
}

class _ImageFormState extends State<ImageForm> {
  int _currentStep = 0;

  Map<String, double> bbox = {};

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep != 2 ? setState(() => _currentStep += 1) : print('bbox: $bbox');
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
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
              content: FilterStep(),
              isActive: _currentStep >= 0,
              state:
                  _currentStep >= 2 ? StepState.complete : StepState.disabled,
            ),
          ],
        ),
      ),
    );
  }

  void setCoordinates(Map<String, dynamic> coordinates) {
    setState(() {
      bbox['lat1'] = coordinates['lat1'];
      bbox['lon1'] = coordinates['lon1'];
      bbox['lat2'] = coordinates['lat2'];
      bbox['lon2'] = coordinates['lon2'];
    });
  }
}
