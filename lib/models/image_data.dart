import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
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

  Future<File> generateKml() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    File file = new File(path.join(documentDirectory.path,
        '${this.getFileName()}.kml'));
    String content = '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
<GroundOverlay>
  <name>${this.title}</name>
  <Icon>
    <href>http://lg1:81/${this.getFileName()}.jpeg</href>
    <viewBoundScale>0.75</viewBoundScale>
  </Icon>
  <LatLonBox>
    <north>-30.0402700200105</north>
    <south>-36.7537780813232</south>
    <east>-51.26031686487932</east>
    <west>-58.3012549790517</west>
    <rotation>-12.76215744018555</rotation>
  </LatLonBox>
</GroundOverlay>
</kml>
    ''';
    print(content);
    file.writeAsString(content);

    return file;
  }

  String getFileName() {
    RegExp regex = RegExp("/data/user/0/com.example.image_satellite_visualizer/app_flutter/(.*).jpeg");
    String path = this.imagePath;
    var fileName = regex.firstMatch(path)?.group(1);
    return fileName!;
  }

  toString() => "imagePath: ${this.imagePath}\n title: ${this.title}\n description: ${this.description}\n coordinates: ${this.coordinates}";
}
