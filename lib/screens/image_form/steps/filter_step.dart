import 'package:flutter/material.dart';

class FilterStep extends StatefulWidget {
  final callback;
  const FilterStep({required this.callback, Key? key}) : super(key: key);

  @override
  _FilterStepState createState() => _FilterStepState();
}

class _FilterStepState extends State<FilterStep> {
  final List<Item> _data = generateItems();

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
              title: Text(item.title),
            );
          },
          body: Column(
            children: List<Widget>.generate(
              item.components.length,
              (index) => InkWell(
                onTap: () {
                  this.widget.callback(item.components[index]);
                  item.selected[index] = !(item.selected[index]);
                },
                child: ListTile(
                  title: Text(item.components[index]),
                  tileColor: item.selected[index] ? Colors.grey[200] : Colors.grey[50],
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
  List<bool> selected;
  bool isExpanded = false;

  Item({
    required this.title,
    required this.components,
    required this.selected,
  });
}

List<Item> generateItems() {
  return List<Item>.generate(products.length, (int index) {
    return Item(
      title: products[index]['title'],
      components: products[index]['components'],
      selected: products[index]['selected'],
    );
  });
}

List<Map<String, dynamic>> products = [
  {
    "title": 'Terra',
    "components": [
      "MODIS_Terra_CorrectedReflectance_TrueColor",
      "MODIS_Terra_CorrectedReflectance_Bands721",
      "MODIS_Terra_CorrectedReflectance_Bands367",
    ],
    "selected": [
      false,
      false,
      false,
    ],
  },
  {
    "title": 'Aqua',
    "components": [
      "MODIS_Aqua_CorrectedReflectance_TrueColor",
      "MODIS_Aqua_CorrectedReflectance_Bands721",
    ],
    "selected": [
      false,
      false,
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
    "selected": [
      false,
      false,
      false,
      false,
      false,
      false,
    ],
  },
  {
    "title": 'VIIRS NOAA20',
    "components": [
      "VIIRS_NOAA20_CorrectedReflectance_TrueColor",
      "VIIRS_NOAA20_CorrectedReflectance_BandsM11-I2-I1",
      "VIIRS_NOAA20_CorrectedReflectance_BandsM3-I3-M11",
    ],
    "selected": [
      false,
      false,
      false,
    ],
  },
];
