import 'dart:io';

import 'package:flutter/material.dart';

class FinalStep extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final String? image;

  const FinalStep(this.nameController, this.descriptionController, this.image,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return image == null
        ? Container(
            height: screenSize.height * 0.65,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Container(
            height: screenSize.height * 0.65,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: screenSize.height * 0.5,
                  width: screenSize.width * 0.4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Image',
                        style: TextStyle(fontSize: screenSize.height * 0.05),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(bottom: screenSize.height * 0.02),
                        child: Text(
                          'Image to be saved',
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: screenSize.height * 0.05),
                        child: Container(
                          height: screenSize.height * 0.35,
                          width: screenSize.width * 0.35,
                          child: Image.file(
                            File(image!),
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: screenSize.height * 0.5,
                  width: screenSize.width * 0.4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Information',
                        style: TextStyle(fontSize: screenSize.height * 0.05),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(bottom: screenSize.height * 0.01),
                        child: Text(
                          'Select name and description of your image',
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: screenSize.width * 0.008,
                            top: screenSize.height * 0.05),
                        child: TextField(
                          controller: nameController,
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
                        padding: EdgeInsets.only(
                          left: screenSize.width * 0.008,
                          top: screenSize.height * 0.02,
                        ),
                        child: TextField(
                          controller: descriptionController,
                          maxLines: 8,
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
                ),
              ],
            ),
          );
  }
}
