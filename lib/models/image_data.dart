import 'package:hive/hive.dart';
  part 'image_data.g.dart';

@HiveType(typeId: 0)
class ImageData extends HiveObject{
  @HiveField(0)
  final String imagePath;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String coordinates;

  ImageData({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.coordinates,
  });

  String generateKml() {
    return '''
      <?xml version="1.0" encoding="UTF-8"?>
      <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
      <GroundOverlay>
        <name>${this.title}</name>
        <Icon>
          <href>${this.imagePath}</href>
          <viewBoundScale>0.75</viewBoundScale>
        </Icon>
        <LatLonBox>
          <north>-3.114756559136379</north>
          <south>-18.51027347066843</south>
          <east>-41.49058667312322</east>
          <west>-57.11944425848938</west>
        </LatLonBox>
      </GroundOverlay>
      </kml>
    ''';
  }

  toString() => "imagePath: ${this.imagePath}\n title: ${this.title}\n description: ${this.description}\n coordinates: ${this.coordinates}";
}
