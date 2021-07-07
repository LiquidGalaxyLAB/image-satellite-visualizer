import 'package:flutter/material.dart';

class FilterStep extends StatefulWidget {
  final callback;
  final String layer;

  const FilterStep(this.layer, this.callback, {Key? key}) : super(key: key);

  @override
  _FilterStepState createState() => _FilterStepState();
}

class _FilterStepState extends State<FilterStep> {
  final List<Item> _data = generateItems();

  @override
  void initState() {
    _data[0].isExpanded = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  Widget _buildPanel() {
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
                  widget.callback(item.components[index]);
                },
                child: ListTile(
                  title: Text(item.components[index]),
                  tileColor: item.components[index] == widget.layer
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
  final List<String> components;
  bool isExpanded = false;

  Item({
    required this.title,
    required this.components,
  });
}

List<Item> generateItems() {
  return List<Item>.generate(
    products.length,
    (int index) {
      return Item(
        title: products[index]['title'],
        components: products[index]['components'],
      );
    },
  );
}

List<Map<String, dynamic>> products = [
  {
    "title": 'Terra',
    "components": [
      "MODIS_Terra_CorrectedReflectance_TrueColor",
      "MODIS_Terra_CorrectedReflectance_Bands721",
      "MODIS_Terra_CorrectedReflectance_Bands367",
    ],
  },
  {
    "title": 'Aqua',
    "components": [
      "MODIS_Aqua_CorrectedReflectance_TrueColor",
      "MODIS_Aqua_CorrectedReflectance_Bands721",
    ],
  },
  {
    "title": 'VIIRS SNPP',
    "components": [
      "VIIRS_SNPP_CorrectedReflectance_TrueColor",
      "VIIRS_SNPP_CorrectedReflectance_BandsM11-I2-I1",
      "VIIRS_SNPP_CorrectedReflectance_BandsM3-I3-M11",
      "VIIRS_SNPP_DayNightBand_At_Sensor_Radiance",
      "VIIRS_SNPP_DayNightBand_AtSensor_M15",
      "VIIRS_SNPP_DayNightBand_ENCC",
    ],
  },
  {
    "title": 'VIIRS NOAA20',
    "components": [
      "VIIRS_NOAA20_CorrectedReflectance_TrueColor",
      "VIIRS_NOAA20_CorrectedReflectance_BandsM11-I2-I1",
      "VIIRS_NOAA20_CorrectedReflectance_BandsM3-I3-M11",
    ],
  },
];
