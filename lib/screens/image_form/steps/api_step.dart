import 'package:flutter/material.dart';

class ApiStep extends StatelessWidget {
  final callback;
  final String selectedApi;

  const ApiStep(this.selectedApi, this.callback, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: screenSize.height * 0.06),
      height: screenSize.height * 0.65,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              callback('Copernicus');
            },
            child: Container(
              decoration: selectedApi == "Copernicus"
                  ? BoxDecoration(
                      color: Colors.grey[100],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(4, 4), // changes position of shadow
                        ),
                      ],
                    )
                  : BoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: 300,
                      height: 300,
                      child: Image.asset(
                        'assets/copernicus.png',
                        fit: BoxFit.contain,
                        width: 100,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: 250,
                      height: 400,
                      child: Text(
                        'The OData interface is a data access protocol built on core protocols like HTTP and commonly accepted methodologies like REST that can be handled by a large set of client tools as simple as common web browsers, download-managers or computer programs such as cURL or Wget. The Open Data Protocol (OData) enables the creation of REST-based data services, which allow resources, identified using Uniform Resource Identifiers (URIs) and defined in a data model, to be published and consumed by Web clients using simple HTTP messages',
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              callback('Nasa');
            },
            child: Container(
              decoration: selectedApi == "Nasa"
                  ? BoxDecoration(
                      color: Colors.grey[100],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(4, 4), // changes position of shadow
                        ),
                      ],
                    )
                  : BoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: screenSize.height * 0.05),
                      width: 300,
                      height: 300,
                      child: Image.asset(
                        'assets/nasa.png',
                        fit: BoxFit.contain,
                        width: 100,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: 250,
                      height: 400,
                      child: Text(
                        "Visually explore the past and present of our dynamic planet through NASA's Global Imagery Browse Services (GIBS). GIBS provides quick access to over 900 satellite imagery products, covering every part of the world. Most imagery is updated daily - available within a few hours after satellite observation, and some products span almost 30 years. The satellite imagery can be rendered in your own web client or GIS application.",
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              callback('SentinelHub');
            },
            child: Container(
              decoration: selectedApi == "SentinelHub"
                  ? BoxDecoration(
                      color: Colors.grey[100],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(4, 4), // changes position of shadow
                        ),
                      ],
                    )
                  : BoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: 300,
                      height: 300,
                      child: Image.asset(
                        'assets/sentinelhub.png',
                        fit: BoxFit.contain,
                        width: 100,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: 250,
                      height: 400,
                      child: Text(
                        "Sentinel Hub is an engine for processing of petabytes of satellite data. It is opening the doors for machine learning and helping hundreds of application developers worldwide. It makes Sentinel, Landsat, and other Earth observation imagery easily accessible for browsing, visualization and analysis. Scale your system globally with an intuitive and user-friendly interface, without any hassle",
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
