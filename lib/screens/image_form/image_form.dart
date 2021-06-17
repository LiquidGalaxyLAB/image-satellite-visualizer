import 'package:flutter/material.dart';
import 'package:image_satellite_visualizer/screens/image_form/steps/api_step.dart';
import 'package:image_satellite_visualizer/screens/image_form/steps/data_step.dart';

class ImageForm extends StatefulWidget {
  const ImageForm({Key? key}) : super(key: key);

  @override
  _ImageFormState createState() => _ImageFormState();
}

class _ImageFormState extends State<ImageForm> {
  int _currentStep = 0;

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
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
              title: new Text('Address'),
              content: DataStep(),
              isActive: _currentStep >= 0,
              state:
                  _currentStep >= 1 ? StepState.complete : StepState.disabled,
            ),
            Step(
              title: new Text('Mobile Number'),
              content: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Mobile Number'),
                  ),
                ],
              ),
              isActive: _currentStep >= 0,
              state:
                  _currentStep >= 2 ? StepState.complete : StepState.disabled,
            ),
          ],
        ),
      ),
    );
  }
}
