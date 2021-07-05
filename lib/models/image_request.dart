import 'package:geodesy/geodesy.dart';

class ImageRequest {
  final Geodesy geodesy = Geodesy();
  final List<String> layers;
  final String time;
  final Map<String, dynamic> bbox;

  ImageRequest({
    required this.layers,
    required this.time,
    required this.bbox,
  });

  Map<String, String> getResolutions() {
    int height = (geodesy.distanceBetweenTwoGeoPoints(
                LatLng(this.bbox['lat1'], this.bbox['lon1']),
                LatLng(this.bbox['lat2'], this.bbox['lon1'])) /
            1000)
        .round();
    int width = (geodesy.distanceBetweenTwoGeoPoints(
                LatLng(this.bbox['lat1'], this.bbox['lon1']),
                LatLng(this.bbox['lat1'], this.bbox['lon2'])) /
            1000)
        .round();
    return {
      'height': height.toString(),
      'width': width.toString(),
    };
  }

  String getBoundaries() =>
      '${this.bbox['lat1']},${this.bbox['lon1']},${this.bbox['lat2']},${this.bbox['lon2']}';

  String getRequestUrl() {
    return "https://wvs.earthdata.nasa.gov/api/v1/snapshot?REQUEST=GetSnapshot&LAYERS=${this.layers.join(',')}&CRS=EPSG:4326&TIME=${this.time}&BBOX=${this.getBoundaries()}&FORMAT=image/jpeg&WIDTH=${this.getResolutions()["width"]}&HEIGHT=${this.getResolutions()["height"]}&AUTOSCALE=FALSE";
  }
}
