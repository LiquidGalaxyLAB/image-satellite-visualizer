import 'package:flutter/material.dart';

class FilterStep extends StatefulWidget {
  const FilterStep({Key? key}) : super(key: key);

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
                onTap: () => print(item.components[index]),
                child: ListTile(
                  tileColor: Colors.grey[100],
                  title: Text(item.components[index]),
                  onTap: () => print(
                    item.components[index],
                  ),
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
  return List<Item>.generate(products.length, (int index) {
    return Item(
      title: products[index]['title'],
      components: products[index]['components'],
    );
  });
}

List<Map<String, dynamic>> products = [
  {
    "title": 'Spectral "Weather" Band imagery',
    "components": [
      "Red Visible",
      "Clean Infrared",
      "Air Mass",
    ]
  },
  {
    "title": 'Multiband Imagery',
    "components": [
      "Corrected Reflectance",
      "Surface Reflectance ",
      "Reflectance ",
      "Radiance ",
      "Earth at Night ",
    ]
  },
  {
    "title": 'Atmosphere',
    "components": [
      "Aerosol Optical Depth",
      "Albedo, Aerosol ",
      "Albedo, Cloud ",
      "Albedo, TOA ",
      "Brightness Temperature ",
      "Carbon Dioxide ",
      "Carbon Monoxide ",
      "Cloud Effective Radius ",
      "Cloud Fraction ",
      "Cloud Liquid Water ",
      "Cloud Multi Layer Flag ",
      "Cloud Phase Infrared ",
      "Cloud Phase Optical Properties ",
      "Cloud Optical Thickness ",
      "Cloud Height ",
      "Cloud Top Temperature ",
      "Cloud Pressure ",
      "Cloud Water Path ",
      "Convective Rainwater Source ",
      "Dust ",
      "Evaporation from Turbulence ",
      "Flux, Surface ",
      "Flux, TOA ",
      "Lightning Flashes and Flash Radiance ",
      "Methane ",
      "Nitric Acid ",
      "Nitrogen Dioxide ",
      "Nitrous Oxide ",
      "Ozone ",
      "Particulate Matter ",
      "Precipitation ",
      "Relative Humidity ",
      "Sulfur Dioxide ",
      "Temperature ",
      "UV Dose and Index ",
      "Water Vapor ",
      "Wind Speed ",
    ],
  },
  {
    "title": 'Cryosphere',
    "components": [
      "Freeze/Thaw",
      "Frozen Area",
      "Ice Surface Temperature",
      "Ice Velocity",
      "Sea Ice",
      "Snow Cover",
      "Snow Depth",
      "Snow Mass",
      "Snow Water Equivalent",
    ],
  },
  {
    "title": 'Land',
    "components": [
      "Albedo, Surface",
      "Albedo, White Sky",
      "Brightness Temperature",
      "Digital Elevation Models",
      "Evaporation over Land",
      "Gross Primary Production",
      "Heterotrophic Respiration",
      "Incident Shortwave over Land",
      "Land Cover",
      "Land Surface Temperature",
      "Isotropic Kernel Parameters",
      "Net Ecosystem CO2 Exchange",
      "Photosynthesis and FPAR",
      "Soil Moisture",
      "Soil Temperature",
      "Surface Air Temperature",
      "Surface Relative Humidity",
      "Surface Pressure",
      "Surface Temperature",
      "Vegetation Indices",
      "Vegetation Light Use Efficiency, Percent",
    ],
  },
  {
    "title": 'Biosphere',
    "components": [
      "Biosphere",
    ],
  },
  {
    "title": 'Ocean',
    "components": [
      "Absolute Dynamic Topography",
      "Chlorophyll",
      "Open Water Latent Energy Flux",
      "Photosynthetically Available Radiation",
      "Sea Surface Currents",
      "Sea Surface Height Anomalies",
      "Sea Surface Salinity",
      "Sea Surface Temperature",
      "Sea Surface Temperature Anomalies",
    ],
  },
  {
    "title": 'Human Dimensions',
    "components": ["Human Dimensions"],
  },
  {
    "title": 'Spectral/Engineering',
    "components": [
      "SMAP Ancillary",
      "Radiation, Outgoing",
    ],
  },
  {
    "title": 'Utility Layers',
    "components": [
      "Data/Imagery Masks",
      "Reference Layers",
    ],
  },
];
