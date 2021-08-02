import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FilterStep extends StatefulWidget {
  final callback;
  final String layer;
  final String selectedApi;

  const FilterStep(this.layer, this.callback, this.selectedApi, {Key? key})
      : super(key: key);

  @override
  _FilterStepState createState() => _FilterStepState();
}

class _FilterStepState extends State<FilterStep> {
  List<Item> _data = [];

  @override
  void initState() {
    if (widget.selectedApi == "Nasa") _data = generateItems(nasaLayers);
    if (widget.selectedApi == "SentinelHub")
      _data = generateItems(sentinelHubLayers);
    if (widget.selectedApi == "Copernicus")
      _data = generateItems(copernicusLayers);
    _data[0].isExpanded = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(screenSize),
      ),
    );
  }

  Widget _buildPanel(Size screenSize) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(
                item.title,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            );
          },
          body: Column(
            children: List<Widget>.generate(
              item.components.length,
              (index) => InkWell(
                onTap: () {
                  widget.callback(item.components[index]['value'], item.components[index]['shortName']);
                },
                child: ListTile(
                  title: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(item.components[index]['name']!),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.all(screenSize.height * 0.008),
                        child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Row(
                                    children: [
                                      Text(item.components[index]['name']!),
                                      Spacer(),
                                      InkWell(
                                        onTap: () async {
                                          await launch(
                                              item.components[index]['url']!);
                                        },
                                        child: Text(
                                          "Learn more",
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  content: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: screenSize.height * 0.3,
                                          width: screenSize.height * 0.3,
                                          child: Image.asset(
                                            item.components[index]['image']!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  screenSize.width * 0.03),
                                          child: Text(
                                            item.components[index]
                                                ['description']!,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 6,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.info),
                          splashRadius: screenSize.height * 0.035,
                        ),
                      ),
                    ],
                  ),
                  tileColor: item.components[index]['value'] == widget.layer
                      ? Colors.grey[200]
                      : Colors.grey[50],
                ),
              ),
            ),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}

class Item {
  final String title;
  final List<Map<String, String>> components;
  bool isExpanded = false;

  Item({
    required this.title,
    required this.components,
  });
}

List<Item> generateItems(List<Map<String, dynamic>> layers) {
  return List<Item>.generate(
    layers.length,
    (int index) {
      return Item(
        title: layers[index]['title'],
        components: layers[index]['components'],
      );
    },
  );
}

List<Map<String, dynamic>> nasaLayers = [
  {
    "title": 'Terra',
    "components": [
      {
        "value": "MODIS_Terra_CorrectedReflectance_TrueColor",
        "shortName": "Terra - True Color",
        "name": "MODIS True Color - Terra Corrected Reflectance",
        "image": "assets/examples/modis_truecolor.png",
        "description":
            "These images are called true-color or natural color because this combination of wavelengths is similar to what the human eye would see. The images are natural-looking images of land surface, oceanic and atmospheric features. The downside of this set of bands is that they tend to produce a hazy image.",
        "url":
            "https://earthdata.nasa.gov/faq/worldview-snapshots-faq#base-layers",
      },
      {
        "value": "MODIS_Terra_CorrectedReflectance_Bands721",
        "shortName": "Terra - 721",
        "name": "MODIS Bands 721 - Terra Corrected Reflectance",
        "image": "assets/examples/modis_721.png",
        "description":
            "This combination is most useful for distinguishing burn scars from naturally low vegetation or bare soil and enhancing floods. This combination can also be used to distinguish snow and ice from clouds. Snow and ice are very reflective in the visible part of the spectrum (Band 1), and absorbent in Bands 2 (near infrared) and 7 (short-wave infrared, or SWIR). Thick ice and snow appear vivid sky blue, while small ice crystals in high-level clouds will also appear blueish, and water clouds will appear white.",
        "url":
            "https://earthdata.nasa.gov/faq/worldview-snapshots-faq#base-layers",
      },
      {
        "value": "MODIS_Terra_CorrectedReflectance_Bands367",
        "shortName": "Terra - 367",
        "name": "MODIS Bands 367 - Terra Corrected Reflectance",
        "image": "assets/examples/modis_367.png",
        "description":
            "This combination is used to map snow and ice. Snow and ice are very reflective in the visible part of the spectrum (Band 3), and very absorbent in Bands 6 and 7 (short-wave infrared, or SWIR). This band combination is good for distinguishing liquid water from frozen water, for example, clouds over snow, ice cloud versus water cloud; or floods from dense vegetation. This band combination is only available for MODIS (Terra) because 70% of the band 6 sensors on the MODIS instrument on NASA's Aqua satellite failed shortly after launch.",
        "url":
            "https://earthdata.nasa.gov/faq/worldview-snapshots-faq#base-layers",
      },
    ],
  },
  {
    "title": 'Aqua',
    "components": [
      {
        "value": "MODIS_Aqua_CorrectedReflectance_TrueColor",
        "shortName": "Aqua - True Color",
        "name": "MODIS True Color - Aqua Corrected Reflectance",
        "image": "assets/examples/aqua_truecolor.png",
        "description":
            "These images are called true-color or natural color because this combination of wavelengths is similar to what the human eye would see. The images are natural-looking images of land surface, oceanic and atmospheric features. The downside of this set of bands is that they tend to produce a hazy image.",
        "url":
            "https://earthdata.nasa.gov/faq/worldview-snapshots-faq#base-layers",
      },
      {
        "value": "MODIS_Aqua_CorrectedReflectance_Bands721",
        "shortName": "Aqua - 721",
        "name": "MODIS Bands 7-2-1 - Aqua Corrected Reflectance",
        "image": "assets/examples/aqua_721.png",
        "description":
            "This combination is most useful for distinguishing burn scars from naturally low vegetation or bare soil and enhancing floods. This combination can also be used to distinguish snow and ice from clouds. Snow and ice are very reflective in the visible part of the spectrum (Band 1), and absorbent in Bands 2 (near infrared) and 7 (short-wave infrared, or SWIR). Thick ice and snow appear vivid sky blue, while small ice crystals in high-level clouds will also appear blueish, and water clouds will appear white.",
        "url":
            "https://earthdata.nasa.gov/faq/worldview-snapshots-faq#base-layers",
      },
    ],
  },
  {
    "title": 'VIIRS SNPP',
    "components": [
      {
        "value": "VIIRS_SNPP_CorrectedReflectance_TrueColor",
        "shortName": "VIIRS - True Color",
        "name": "VIIRS True Color - SNPP Corrected Reflectance",
        "image": "assets/examples/viirs_truecolor.png",
        "description":
            "These images are called true-color or natural color because this combination of wavelengths is similar to what the human eye would see. The images are natural-looking images of land surface, oceanic and atmospheric features.",
        "url":
            "https://earthdata.nasa.gov/faq/worldview-snapshots-faq#base-layers",
      },
      {
        "value": "VIIRS_SNPP_CorrectedReflectance_BandsM11-I2-I1",
        "shortName": "VIIRS - M11/I2/I1",
        "name": "VIIRS Bands M11-I2-I1 - SNPP Corrected Reflectance",
        "image": "assets/examples/viirs_m11.png",
        "description":
            "This combination is most useful for distinguishing burn scars from naturally low vegetation or bare soil and enhancing floods. This combination can also be used to distinguish snow and ice from clouds. Snow and ice are very reflective in the visible part of the spectrum (Band I1), and absorbent in Bands I2 (near infrared) and M11 (short-wave infrared, or SWIR). Thick ice and snow appear vivid sky blue, while small ice crystals in high-level clouds will also appear blueish, and water clouds will appear white. The VIIRS instrument in aboard the joint NASA/NOAA Suomi NPP satellite.",
        "url":
            "https://earthdata.nasa.gov/faq/worldview-snapshots-faq#base-layers",
      },
      {
        "value": "VIIRS_SNPP_CorrectedReflectance_BandsM3-I3-M11",
        "shortName": "VIIRS - M3/I3/M11",
        "name": "VIIRS Bands M3-I3-M111 - SNPP Corrected Reflectance",
        "image": "assets/examples/viirs_m3.png",
        "description":
            "This combination is used to map snow and ice. Snow and ice are very reflective in the visible part of the spectrum (Band M3), and very absorbent in Bands I3 and M11 (short-wave infrared, or SWIR). This band combination is good for distinguishing liquid water from frozen water, for example, clouds over snow, ice cloud versus water cloud; or floods from dense vegetation. The VIIRS instrument in aboard the joint NASA/NOAA Suomi NPP satellite.",
        "url":
            "https://earthdata.nasa.gov/faq/worldview-snapshots-faq#base-layers",
      },
      {
        "value": "VIIRS_SNPP_DayNightBand_ENCC",
        "shortName": "VIIRS - Day Night Band",
        "name": "VIIR SNPP Day/Night Band, ENCC (Nighttime imagery)",
        "image": "assets/examples/viirs_daynight.png",
        "description":
            "The VIIRS Nighttime Imagery (Day/Night Band, Enhanced Near Constant Contrast) shows the Earth’s surface and atmosphere using a sensor designed to capture low-light emission sources, under varying illumination conditions. It is displayed as a grayscale image. Sources of illumination include both natural and anthropogenic sources of light emissions. Lunar reflection can be used to highlight the location and features of clouds and other terrestrial features such as sea ice and snow cover when there is partial to full moon conditions. When there is no moonlight, natural and anthropogenic night time light emissions are highlighted such as city lights, lightning, upper-atmospheric gravity waves, auroras, fires, gas flares, and fishing fleets. This layer is useful for displaying cities and highways at night, the tracking of shipping and fishing fleets, as well as fires and the burning of waste natural gas (gas flares) from on and offshore oil/gas production sites.",
        "url":
            "https://earthdata.nasa.gov/faq/worldview-snapshots-faq#base-layers",
      },
    ],
  },
];

List<Map<String, dynamic>> sentinelHubLayers = [
  {
    "title": 'Band 1',
    "components": [
      {
        "value": "BATHYMETRIC",
        "shortName": "Bathymetric",
        "name": "Bathymetric",
        "image": "assets/examples/bathymetric.png",
        "description":
            "The main goal of the script is to identify shallow water depths (up to 18 meters) for selected area and specific scene. Sentinel Hub services provide cost-effective and fast evaluation of shallow bathymetry compared to extensive sonar or in-situ measurements of depth. Nevertheless, if input parameters scale (m1) and offset (m0) for calculation of Satellite Derived Bathymetry (SDB) are unknown, at least 5-10 calibration points with known depth [1] and minor work of the platform are needed. For some locations, bathymetry data can be found online or one could make in-situ measurements.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
    ],
  },
  {
    "title": 'Band 2',
    "components": [
      {
        "value": "NATURAL-COLOR",
        "shortName": "Natural Color",
        "name": "Natural Color",
        "image": "assets/examples/natural_color.png",
        "description":
            "The natural color band combination uses the red (B4), green (B3), and blue (B2) channels. Its purpose is to display imagery the same way our eyes see the world. Just like how we see, healthy vegetation is green. Next, urban features often appear white and grey. Finally, water is a shade of dark blue depending on how clean it is.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "AGRICULTURE",
        "shortName": "Agriculture",
        "name": "Agriculture",
        "image": "assets/examples/agriculture.png",
        "description":
            "This composite, often called the Agriculture RGB composite, uses bands SWIR-1 (B11), near-infrared (B08) and blue (B02). It’s mostly used to monitor crop health, as both short-wave and near infrared bands are particularly good at highlighting dense vegetation, which appears dark green in the composite. SWIR measurements can help scientists estimate how much water is present in plants and soil, as water reflects SWIR light. Shortwave-infrared bands are also useful for distinguishing between snow, and ice, all of which appear white in visible light. Newly burned land reflects strongly in SWIR bands, making them valuable for mapping fire damage.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "GEOLOGY",
        "shortName": "Geology",
        "name": "Geology",
        "image": "assets/examples/geology.png",
        "description":
            "This composite, often called the Agriculture RGB composite, uses bands SWIR-1 (B11), near-infrared (B08) and blue (B02). It’s mostly used to monitor crop health, as both short-wave and near infrared bands are particularly good at highlighting dense vegetation, which appears dark green in the composite. SWIR measurements can help scientists estimate how much water is present in plants and soil, as water reflects SWIR light. Shortwave-infrared bands are also useful for distinguishing between snow, and ice, all of which appear white in visible light. Newly burned land reflects strongly in SWIR bands, making them valuable for mapping fire damage.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
    ],
  },
  {
    "title": 'Band 3',
    "components": [
      {
        "value": "NATURAL-COLOR",
        "shortName": "Natural Color",
        "name": "Natural Color",
        "image": "assets/examples/natural_color.png",
        "description":
            "The natural color band combination uses the red (B4), green (B3), and blue (B2) channels. Its purpose is to display imagery the same way our eyes see the world. Just like how we see, healthy vegetation is green. Next, urban features often appear white and grey. Finally, water is a shade of dark blue depending on how clean it is.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "FALSE-COLOR",
        "shortName": "False Color",
        "name": "False Color",
        "image": "assets/examples/false_color.png",
        "description":
            "False color imagery is displayed in a combination of standard near infra-red, red and green band. False color composite using near infrared, red and green bands is very popular. It is most commonly used to assess plant density and healht, as plants reflect near infrared and green light, while absorbing red. Since they reflect more near infrared than green, plant-covered land appears deep red. Denser plant growth is darker red. Cities and exposed ground are gray or tan, and water appears blue or black.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "BATHYMETRIC",
        "shortName": "Bathymetric",
        "name": "Bathymetric",
        "image": "assets/examples/bathymetric.png",
        "description":
            "The main goal of the script is to identify shallow water depths (up to 18 meters) for selected area and specific scene. Sentinel Hub services provide cost-effective and fast evaluation of shallow bathymetry compared to extensive sonar or in-situ measurements of depth. Nevertheless, if input parameters scale (m1) and offset (m0) for calculation of Satellite Derived Bathymetry (SDB) are unknown, at least 5-10 calibration points with known depth [1] and minor work of the platform are needed. For some locations, bathymetry data can be found online or one could make in-situ measurements.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
    ],
  },
  {
    "title": 'Band 4',
    "components": [
      {
        "value": "NATURAL-COLOR",
        "shortName": "Natural Color",
        "name": "Natural Color",
        "image": "assets/examples/natural_color.png",
        "description":
            "The natural color band combination uses the red (B4), green (B3), and blue (B2) channels. Its purpose is to display imagery the same way our eyes see the world. Just like how we see, healthy vegetation is green. Next, urban features often appear white and grey. Finally, water is a shade of dark blue depending on how clean it is.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "FALSE-COLOR",
        "shortName": "False Color",
        "name": "False Color",
        "image": "assets/examples/false_color.png",
        "description":
            "False color imagery is displayed in a combination of standard near infra-red, red and green band. False color composite using near infrared, red and green bands is very popular. It is most commonly used to assess plant density and healht, as plants reflect near infrared and green light, while absorbing red. Since they reflect more near infrared than green, plant-covered land appears deep red. Denser plant growth is darker red. Cities and exposed ground are gray or tan, and water appears blue or black.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "NDVI",
        "shortName": "NDVI",
        "name": "Normalized difference vegetation index",
        "image": "assets/examples/ndvi.png",
        "description":
            "The well known and widely used NDVI is a simple, but effective index forß quantifying green vegetation. It normalizes green leaf scattering in Near Infra-red wavelengths with chlorophyll absorption in red wavelengths.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "FALSE-COLOR-URBAN",
        "shortName": "False Color Urban",
        "name": "False Color Urban Composite",
        "image": "assets/examples/false_color_urban.png",
        "description":
            "This composite is used to visualize urbanized areas more clearly. Vegetation is visible in shades of green, while urbanized areas are represented by white, grey, or purple. Soils, sand, and minerals are shown in a variety of colors. Snow and ice appear as dark blue, and water as black or blue. Flooded areas are very dark blue and almost black. The composite is useful for detecting wildfires and calderas of volcanoes, as they are displayed in shades of red and yellow.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "SWIR",
        "shortName": "SWIR",
        "name": "SWIR",
        "image": "assets/examples/swir.png",
        "description":
            "Short wave infrared (SWIR) bands 11 and 12 can help scientists estimate how much water is present in plants and soil, as water reflects SWIR wavelengths. Shortwave-infrared bands are also useful for distinguishing between cloud types (water clouds versus ice clouds), snow and ice, all of which appear white in visible light. Newly burned land reflects strongly in SWIR bands, making them valuable for mapping fire damage. Each rock type reflects shortwave infrared light differently, making it possible to map out geology by comparing reflected SWIR light. In this composite, B8A is reflected by vegetation and shown in the green channel, while the reflected red band, highlighting bare soil and built up areas, is shown in the blue channel.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "BATHYMETRIC",
        "shortName": "Bathymetric",
        "name": "Bathymetric",
        "image": "assets/examples/bathymetric.png",
        "description":
            "The main goal of the script is to identify shallow water depths (up to 18 meters) for selected area and specific scene. Sentinel Hub services provide cost-effective and fast evaluation of shallow bathymetry compared to extensive sonar or in-situ measurements of depth. Nevertheless, if input parameters scale (m1) and offset (m0) for calculation of Satellite Derived Bathymetry (SDB) are unknown, at least 5-10 calibration points with known depth [1] and minor work of the platform are needed. For some locations, bathymetry data can be found online or one could make in-situ measurements.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "GEOLOGY",
        "shortName": "Geology",
        "name": "Geology",
        "image": "assets/examples/geology.png",
        "description":
            "This composite, often called the Agriculture RGB composite, uses bands SWIR-1 (B11), near-infrared (B08) and blue (B02). It’s mostly used to monitor crop health, as both short-wave and near infrared bands are particularly good at highlighting dense vegetation, which appears dark green in the composite. SWIR measurements can help scientists estimate how much water is present in plants and soil, as water reflects SWIR light. Shortwave-infrared bands are also useful for distinguishing between snow, and ice, all of which appear white in visible light. Newly burned land reflects strongly in SWIR bands, making them valuable for mapping fire damage.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
    ],
  },
  {
    "title": 'Band 8',
    "components": [
      {
        "value": "FALSE-COLOR",
        "shortName": "False Color",
        "name": "False Color",
        "image": "assets/examples/false_color.png",
        "description":
            "False color imagery is displayed in a combination of standard near infra-red, red and green band. False color composite using near infrared, red and green bands is very popular. It is most commonly used to assess plant density and healht, as plants reflect near infrared and green light, while absorbing red. Since they reflect more near infrared than green, plant-covered land appears deep red. Denser plant growth is darker red. Cities and exposed ground are gray or tan, and water appears blue or black.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "NDVI",
        "shortName": "NDVI",
        "name": "Normalized difference vegetation index",
        "image": "assets/examples/ndvi.png",
        "description":
            "The well known and widely used NDVI is a simple, but effective index for quantifying green vegetation. It normalizes green leaf scattering in Near Infra-red wavelengths with chlorophyll absorption in red wavelengths.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "MOISTURE-INDEX",
        "shortName": "Moisture",
        "name": "Normalized Difference Moisture Index",
        "image": "assets/examples/moisture_index.png",
        "description":
            "The NDMI is a normalized difference moisture index, that uses NIR and SWIR bands to display moisture. The SWIR band reflects changes in both the vegetation water content and the spongy mesophyll structure in vegetation canopies, while the NIR reflectance is affected by leaf internal structure and leaf dry matter content but not by water content. The combination of the NIR with the SWIR removes variations induced by leaf internal structure and leaf dry matter content, improving the accuracy in retrieving the vegetation water content.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "AGRICULTURE",
        "shortName": "Agriculture",
        "name": "Agriculture",
        "image": "assets/examples/agriculture.png",
        "description":
            "This composite, often called the Agriculture RGB composite, uses bands SWIR-1 (B11), near-infrared (B08) and blue (B02). It’s mostly used to monitor crop health, as both short-wave and near infrared bands are particularly good at highlighting dense vegetation, which appears dark green in the composite. SWIR measurements can help scientists estimate how much water is present in plants and soil, as water reflects SWIR light. Shortwave-infrared bands are also useful for distinguishing between snow, and ice, all of which appear white in visible light. Newly burned land reflects strongly in SWIR bands, making them valuable for mapping fire damage.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
    ],
  },
  {
    "title": 'Band 11',
    "components": [
      {
        "value": "FALSE-COLOR-URBAN",
        "shortName": "False Color Urban",
        "name": "False Color Urban Composite",
        "image": "assets/examples/false_color_urban.png",
        "description":
            "This composite is used to visualize urbanized areas more clearly. Vegetation is visible in shades of green, while urbanized areas are represented by white, grey, or purple. Soils, sand, and minerals are shown in a variety of colors. Snow and ice appear as dark blue, and water as black or blue. Flooded areas are very dark blue and almost black. The composite is useful for detecting wildfires and calderas of volcanoes, as they are displayed in shades of red and yellow.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "MOISTURE-INDEX",
        "shortName": "Moisture",
        "name": "Normalized Difference Moisture Index",
        "image": "assets/examples/moisture_index.png",
        "description":
            "The NDMI is a normalized difference moisture index, that uses NIR and SWIR bands to display moisture. The SWIR band reflects changes in both the vegetation water content and the spongy mesophyll structure in vegetation canopies, while the NIR reflectance is affected by leaf internal structure and leaf dry matter content but not by water content. The combination of the NIR with the SWIR removes variations induced by leaf internal structure and leaf dry matter content, improving the accuracy in retrieving the vegetation water content.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "SWIR",
        "shortName": "SWIR",
        "name": "SWIR",
        "image": "assets/examples/swir.png",
        "description":
            "Short wave infrared (SWIR) bands 11 and 12 can help scientists estimate how much water is present in plants and soil, as water reflects SWIR wavelengths. Shortwave-infrared bands are also useful for distinguishing between cloud types (water clouds versus ice clouds), snow and ice, all of which appear white in visible light. Newly burned land reflects strongly in SWIR bands, making them valuable for mapping fire damage. Each rock type reflects shortwave infrared light differently, making it possible to map out geology by comparing reflected SWIR light. In this composite, B8A is reflected by vegetation and shown in the green channel, while the reflected red band, highlighting bare soil and built up areas, is shown in the blue channel.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "AGRICULTURE",
        "shortName": "Agrilculture",
        "name": "Agriculture",
        "image": "assets/examples/agriculture.png",
        "description":
            "This composite, often called the Agriculture RGB composite, uses bands SWIR-1 (B11), near-infrared (B08) and blue (B02). It’s mostly used to monitor crop health, as both short-wave and near infrared bands are particularly good at highlighting dense vegetation, which appears dark green in the composite. SWIR measurements can help scientists estimate how much water is present in plants and soil, as water reflects SWIR light. Shortwave-infrared bands are also useful for distinguishing between snow, and ice, all of which appear white in visible light. Newly burned land reflects strongly in SWIR bands, making them valuable for mapping fire damage.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
    ],
  },
  {
    "title": 'Band 12',
    "components": [
      {
        "value": "FALSE-COLOR-URBAN",
        "shortName": "False Color Urban",
        "name": "False Color Urban Composite",
        "image": "assets/examples/false_color_urban.png",
        "description":
            "This composite is used to visualize urbanized areas more clearly. Vegetation is visible in shades of green, while urbanized areas are represented by white, grey, or purple. Soils, sand, and minerals are shown in a variety of colors. Snow and ice appear as dark blue, and water as black or blue. Flooded areas are very dark blue and almost black. The composite is useful for detecting wildfires and calderas of volcanoes, as they are displayed in shades of red and yellow.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "SWIR",
        "shortName": "SWIR",
        "name": "SWIR",
        "image": "assets/examples/swir.png",
        "description":
            "Short wave infrared (SWIR) bands 11 and 12 can help scientists estimate how much water is present in plants and soil, as water reflects SWIR wavelengths. Shortwave-infrared bands are also useful for distinguishing between cloud types (water clouds versus ice clouds), snow and ice, all of which appear white in visible light. Newly burned land reflects strongly in SWIR bands, making them valuable for mapping fire damage. Each rock type reflects shortwave infrared light differently, making it possible to map out geology by comparing reflected SWIR light. In this composite, B8A is reflected by vegetation and shown in the green channel, while the reflected red band, highlighting bare soil and built up areas, is shown in the blue channel.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "GEOLOGY",
        "shortName": "Geology",
        "name": "Geology",
        "image": "assets/examples/geology.png",
        "description":
            "This composite, often called the Agriculture RGB composite, uses bands SWIR-1 (B11), near-infrared (B08) and blue (B02). It’s mostly used to monitor crop health, as both short-wave and near infrared bands are particularly good at highlighting dense vegetation, which appears dark green in the composite. SWIR measurements can help scientists estimate how much water is present in plants and soil, as water reflects SWIR light. Shortwave-infrared bands are also useful for distinguishing between snow, and ice, all of which appear white in visible light. Newly burned land reflects strongly in SWIR bands, making them valuable for mapping fire damage.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
    ],
  },
];

List<Map<String, dynamic>> copernicusLayers = [
  {
    "title": 'Sentinel 2 - Band 1',
    "components": [
      {
        "value": "BATHYMETRIC",
        "shortName": "Bathymetric",
        "name": "Bathymetric",
        "image": "assets/examples/bathymetric.png",
        "description":
            "The main goal of the script is to identify shallow water depths (up to 18 meters) for selected area and specific scene. Sentinel Hub services provide cost-effective and fast evaluation of shallow bathymetry compared to extensive sonar or in-situ measurements of depth. Nevertheless, if input parameters scale (m1) and offset (m0) for calculation of Satellite Derived Bathymetry (SDB) are unknown, at least 5-10 calibration points with known depth [1] and minor work of the platform are needed. For some locations, bathymetry data can be found online or one could make in-situ measurements.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
    ],
  },
  {
    "title": 'Sentinel 2 - Band 2',
    "components": [
      {
        "value": "NATURAL-COLOR",
        "shortName": "Natural Color",
        "name": "Natural Color",
        "image": "assets/examples/natural_color.png",
        "description":
            "The natural color band combination uses the red (B4), green (B3), and blue (B2) channels. Its purpose is to display imagery the same way our eyes see the world. Just like how we see, healthy vegetation is green. Next, urban features often appear white and grey. Finally, water is a shade of dark blue depending on how clean it is.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "AGRICULTURE",
        "shortName": "Agriculture",
        "name": "Agriculture",
        "image": "assets/examples/agriculture.png",
        "description":
            "This composite, often called the Agriculture RGB composite, uses bands SWIR-1 (B11), near-infrared (B08) and blue (B02). It’s mostly used to monitor crop health, as both short-wave and near infrared bands are particularly good at highlighting dense vegetation, which appears dark green in the composite. SWIR measurements can help scientists estimate how much water is present in plants and soil, as water reflects SWIR light. Shortwave-infrared bands are also useful for distinguishing between snow, and ice, all of which appear white in visible light. Newly burned land reflects strongly in SWIR bands, making them valuable for mapping fire damage.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "GEOLOGY",
        "shortName": "Geology",
        "name": "Geology",
        "image": "assets/examples/geology.png",
        "description":
            "This composite, often called the Agriculture RGB composite, uses bands SWIR-1 (B11), near-infrared (B08) and blue (B02). It’s mostly used to monitor crop health, as both short-wave and near infrared bands are particularly good at highlighting dense vegetation, which appears dark green in the composite. SWIR measurements can help scientists estimate how much water is present in plants and soil, as water reflects SWIR light. Shortwave-infrared bands are also useful for distinguishing between snow, and ice, all of which appear white in visible light. Newly burned land reflects strongly in SWIR bands, making them valuable for mapping fire damage.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
    ],
  },
  {
    "title": 'Sentinel 2 - Band 3',
    "components": [
      {
        "value": "NATURAL-COLOR",
        "shortName": "Natural Color",
        "name": "Natural Color",
        "image": "assets/examples/natural_color.png",
        "description":
            "The natural color band combination uses the red (B4), green (B3), and blue (B2) channels. Its purpose is to display imagery the same way our eyes see the world. Just like how we see, healthy vegetation is green. Next, urban features often appear white and grey. Finally, water is a shade of dark blue depending on how clean it is.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "FALSE-COLOR",
        "shortName": "False Color",
        "name": "False Color",
        "image": "assets/examples/false_color.png",
        "description":
            "False color imagery is displayed in a combination of standard near infra-red, red and green band. False color composite using near infrared, red and green bands is very popular. It is most commonly used to assess plant density and healht, as plants reflect near infrared and green light, while absorbing red. Since they reflect more near infrared than green, plant-covered land appears deep red. Denser plant growth is darker red. Cities and exposed ground are gray or tan, and water appears blue or black.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "BATHYMETRIC",
        "shortName": "Bathymetric",
        "name": "Bathymetric",
        "image": "assets/examples/bathymetric.png",
        "description":
            "The main goal of the script is to identify shallow water depths (up to 18 meters) for selected area and specific scene. Sentinel Hub services provide cost-effective and fast evaluation of shallow bathymetry compared to extensive sonar or in-situ measurements of depth. Nevertheless, if input parameters scale (m1) and offset (m0) for calculation of Satellite Derived Bathymetry (SDB) are unknown, at least 5-10 calibration points with known depth [1] and minor work of the platform are needed. For some locations, bathymetry data can be found online or one could make in-situ measurements.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
    ],
  },
  {
    "title": 'Sentinel 2 - Band 4',
    "components": [
      {
        "value": "NATURAL-COLOR",
        "shortName": "Natural Color",
        "name": "Natural Color",
        "image": "assets/examples/natural_color.png",
        "description":
            "The natural color band combination uses the red (B4), green (B3), and blue (B2) channels. Its purpose is to display imagery the same way our eyes see the world. Just like how we see, healthy vegetation is green. Next, urban features often appear white and grey. Finally, water is a shade of dark blue depending on how clean it is.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "FALSE-COLOR",
        "shortName": "False Color",
        "name": "False Color",
        "image": "assets/examples/false_color.png",
        "description":
            "False color imagery is displayed in a combination of standard near infra-red, red and green band. False color composite using near infrared, red and green bands is very popular. It is most commonly used to assess plant density and healht, as plants reflect near infrared and green light, while absorbing red. Since they reflect more near infrared than green, plant-covered land appears deep red. Denser plant growth is darker red. Cities and exposed ground are gray or tan, and water appears blue or black.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "NDVI",
        "shortName": "NDVI",
        "name": "Normalized difference vegetation index",
        "image": "assets/examples/ndvi.png",
        "description":
            "The well known and widely used NDVI is a simple, but effective index forß quantifying green vegetation. It normalizes green leaf scattering in Near Infra-red wavelengths with chlorophyll absorption in red wavelengths.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "FALSE-COLOR-URBAN",
        "shortName": "False Color Urban",
        "name": "False Color Urban Composite",
        "image": "assets/examples/false_color_urban.png",
        "description":
            "This composite is used to visualize urbanized areas more clearly. Vegetation is visible in shades of green, while urbanized areas are represented by white, grey, or purple. Soils, sand, and minerals are shown in a variety of colors. Snow and ice appear as dark blue, and water as black or blue. Flooded areas are very dark blue and almost black. The composite is useful for detecting wildfires and calderas of volcanoes, as they are displayed in shades of red and yellow.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "SWIR",
        "shortName": "SWIR",
        "name": "SWIR",
        "image": "assets/examples/swir.png",
        "description":
            "Short wave infrared (SWIR) bands 11 and 12 can help scientists estimate how much water is present in plants and soil, as water reflects SWIR wavelengths. Shortwave-infrared bands are also useful for distinguishing between cloud types (water clouds versus ice clouds), snow and ice, all of which appear white in visible light. Newly burned land reflects strongly in SWIR bands, making them valuable for mapping fire damage. Each rock type reflects shortwave infrared light differently, making it possible to map out geology by comparing reflected SWIR light. In this composite, B8A is reflected by vegetation and shown in the green channel, while the reflected red band, highlighting bare soil and built up areas, is shown in the blue channel.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "BATHYMETRIC",
        "shortName": "Bathymetric",
        "name": "Bathymetric",
        "image": "assets/examples/bathymetric.png",
        "description":
            "The main goal of the script is to identify shallow water depths (up to 18 meters) for selected area and specific scene. Sentinel Hub services provide cost-effective and fast evaluation of shallow bathymetry compared to extensive sonar or in-situ measurements of depth. Nevertheless, if input parameters scale (m1) and offset (m0) for calculation of Satellite Derived Bathymetry (SDB) are unknown, at least 5-10 calibration points with known depth [1] and minor work of the platform are needed. For some locations, bathymetry data can be found online or one could make in-situ measurements.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "GEOLOGY",
        "shortName": "Geology",
        "name": "Geology",
        "image": "assets/examples/geology.png",
        "description":
            "This composite, often called the Agriculture RGB composite, uses bands SWIR-1 (B11), near-infrared (B08) and blue (B02). It’s mostly used to monitor crop health, as both short-wave and near infrared bands are particularly good at highlighting dense vegetation, which appears dark green in the composite. SWIR measurements can help scientists estimate how much water is present in plants and soil, as water reflects SWIR light. Shortwave-infrared bands are also useful for distinguishing between snow, and ice, all of which appear white in visible light. Newly burned land reflects strongly in SWIR bands, making them valuable for mapping fire damage.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
    ],
  },
  {
    "title": 'Sentinel 2 - Band 8',
    "components": [
      {
        "value": "FALSE-COLOR",
        "shortName": "False Color",
        "name": "False Color",
        "image": "assets/examples/false_color.png",
        "description":
            "False color imagery is displayed in a combination of standard near infra-red, red and green band. False color composite using near infrared, red and green bands is very popular. It is most commonly used to assess plant density and healht, as plants reflect near infrared and green light, while absorbing red. Since they reflect more near infrared than green, plant-covered land appears deep red. Denser plant growth is darker red. Cities and exposed ground are gray or tan, and water appears blue or black.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "NDVI",
        "shortName": "NDVI",
        "name": "Normalized difference vegetation index",
        "image": "assets/examples/ndvi.png",
        "description":
            "The well known and widely used NDVI is a simple, but effective index for quantifying green vegetation. It normalizes green leaf scattering in Near Infra-red wavelengths with chlorophyll absorption in red wavelengths.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "MOISTURE-INDEX",
        "shortName": "Moisture",
        "name": "Normalized Difference Moisture Index",
        "image": "assets/examples/moisture_index.png",
        "description":
            "The NDMI is a normalized difference moisture index, that uses NIR and SWIR bands to display moisture. The SWIR band reflects changes in both the vegetation water content and the spongy mesophyll structure in vegetation canopies, while the NIR reflectance is affected by leaf internal structure and leaf dry matter content but not by water content. The combination of the NIR with the SWIR removes variations induced by leaf internal structure and leaf dry matter content, improving the accuracy in retrieving the vegetation water content.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "AGRICULTURE",
        "shortName": "Agriculture",
        "name": "Agriculture",
        "image": "assets/examples/agriculture.png",
        "description":
            "This composite, often called the Agriculture RGB composite, uses bands SWIR-1 (B11), near-infrared (B08) and blue (B02). It’s mostly used to monitor crop health, as both short-wave and near infrared bands are particularly good at highlighting dense vegetation, which appears dark green in the composite. SWIR measurements can help scientists estimate how much water is present in plants and soil, as water reflects SWIR light. Shortwave-infrared bands are also useful for distinguishing between snow, and ice, all of which appear white in visible light. Newly burned land reflects strongly in SWIR bands, making them valuable for mapping fire damage.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
    ],
  },
  {
    "title": 'Sentinel 2 - Band 11',
    "components": [
      {
        "value": "FALSE-COLOR-URBAN",
        "shortName": "False Color Urban",
        "name": "False Color Urban Composite",
        "image": "assets/examples/false_color_urban.png",
        "description":
            "This composite is used to visualize urbanized areas more clearly. Vegetation is visible in shades of green, while urbanized areas are represented by white, grey, or purple. Soils, sand, and minerals are shown in a variety of colors. Snow and ice appear as dark blue, and water as black or blue. Flooded areas are very dark blue and almost black. The composite is useful for detecting wildfires and calderas of volcanoes, as they are displayed in shades of red and yellow.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "MOISTURE-INDEX",
        "shortName": "Moisture",
        "name": "Normalized Difference Moisture Index",
        "image": "assets/examples/moisture_index.png",
        "description":
            "The NDMI is a normalized difference moisture index, that uses NIR and SWIR bands to display moisture. The SWIR band reflects changes in both the vegetation water content and the spongy mesophyll structure in vegetation canopies, while the NIR reflectance is affected by leaf internal structure and leaf dry matter content but not by water content. The combination of the NIR with the SWIR removes variations induced by leaf internal structure and leaf dry matter content, improving the accuracy in retrieving the vegetation water content.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "SWIR",
        "shortName": "SWIR",
        "name": "SWIR",
        "image": "assets/examples/swir.png",
        "description":
            "Short wave infrared (SWIR) bands 11 and 12 can help scientists estimate how much water is present in plants and soil, as water reflects SWIR wavelengths. Shortwave-infrared bands are also useful for distinguishing between cloud types (water clouds versus ice clouds), snow and ice, all of which appear white in visible light. Newly burned land reflects strongly in SWIR bands, making them valuable for mapping fire damage. Each rock type reflects shortwave infrared light differently, making it possible to map out geology by comparing reflected SWIR light. In this composite, B8A is reflected by vegetation and shown in the green channel, while the reflected red band, highlighting bare soil and built up areas, is shown in the blue channel.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "AGRICULTURE",
        "shortName": "Agrilculture",
        "name": "Agriculture",
        "image": "assets/examples/agriculture.png",
        "description":
            "This composite, often called the Agriculture RGB composite, uses bands SWIR-1 (B11), near-infrared (B08) and blue (B02). It’s mostly used to monitor crop health, as both short-wave and near infrared bands are particularly good at highlighting dense vegetation, which appears dark green in the composite. SWIR measurements can help scientists estimate how much water is present in plants and soil, as water reflects SWIR light. Shortwave-infrared bands are also useful for distinguishing between snow, and ice, all of which appear white in visible light. Newly burned land reflects strongly in SWIR bands, making them valuable for mapping fire damage.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
    ],
  },
  {
    "title": 'Sentinel 2 - Band 12',
    "components": [
      {
        "value": "FALSE-COLOR-URBAN",
        "shortName": "False Color Urban",
        "name": "False Color Urban Composite",
        "image": "assets/examples/false_color_urban.png",
        "description":
            "This composite is used to visualize urbanized areas more clearly. Vegetation is visible in shades of green, while urbanized areas are represented by white, grey, or purple. Soils, sand, and minerals are shown in a variety of colors. Snow and ice appear as dark blue, and water as black or blue. Flooded areas are very dark blue and almost black. The composite is useful for detecting wildfires and calderas of volcanoes, as they are displayed in shades of red and yellow.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "SWIR",
        "shortName": "SWIR",
        "name": "SWIR",
        "image": "assets/examples/swir.png",
        "description":
            "Short wave infrared (SWIR) bands 11 and 12 can help scientists estimate how much water is present in plants and soil, as water reflects SWIR wavelengths. Shortwave-infrared bands are also useful for distinguishing between cloud types (water clouds versus ice clouds), snow and ice, all of which appear white in visible light. Newly burned land reflects strongly in SWIR bands, making them valuable for mapping fire damage. Each rock type reflects shortwave infrared light differently, making it possible to map out geology by comparing reflected SWIR light. In this composite, B8A is reflected by vegetation and shown in the green channel, while the reflected red band, highlighting bare soil and built up areas, is shown in the blue channel.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
      {
        "value": "GEOLOGY",
        "shortName": "Geology",
        "name": "Geology",
        "image": "assets/examples/geology.png",
        "description":
            "This composite, often called the Agriculture RGB composite, uses bands SWIR-1 (B11), near-infrared (B08) and blue (B02). It’s mostly used to monitor crop health, as both short-wave and near infrared bands are particularly good at highlighting dense vegetation, which appears dark green in the composite. SWIR measurements can help scientists estimate how much water is present in plants and soil, as water reflects SWIR light. Shortwave-infrared bands are also useful for distinguishing between snow, and ice, all of which appear white in visible light. Newly burned land reflects strongly in SWIR bands, making them valuable for mapping fire damage.",
        "url": "https://custom-scripts.sentinel-hub.com/#sentinel-2",
      },
    ],
  },
];