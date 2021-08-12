import 'package:geodesy/geodesy.dart';
import 'package:image_satellite_visualizer/models/resolution.dart';

class ImageRequest {
  final Geodesy geodesy = Geodesy();
  final List<String> layers;
  final String time;
  final Map<String, double> bbox;
  final Resolution resolution;
  final double? cloudCoverage;

  ImageRequest({
    required this.layers,
    required this.time,
    required this.bbox,
    required this.resolution,
    this.cloudCoverage,
  });

  Map<String, String> getResolutions() {
    double height = (geodesy.distanceBetweenTwoGeoPoints(
            LatLng(this.bbox['lat1']!, this.bbox['lon1']!),
            LatLng(this.bbox['lat2']!, this.bbox['lon1']!)) /
        1000);
    double width = (geodesy.distanceBetweenTwoGeoPoints(
            LatLng(this.bbox['lat1']!, this.bbox['lon1']!),
            LatLng(this.bbox['lat1']!, this.bbox['lon2']!)) /
        1000);

    switch (this.resolution) {
      case Resolution.m250:
        height *= 4;
        width *= 4;
        break;
      case Resolution.m500:
        height *= 2;
        width *= 2;
        break;
      case Resolution.km1:
        height *= 1;
        width *= 1;
        break;
      case Resolution.km5:
        height *= 0.2;
        width *= 0.2;
        break;
      case Resolution.km10:
        height *= 0.1;
        width *= 0.1;
        break;
    }

    return {
      'height': height.round().toString(),
      'width': width.round().toString(),
    };
  }

  String getBoundaries() =>
      '${this.bbox['lat1']},${this.bbox['lon1']},${this.bbox['lat2']},${this.bbox['lon2']}';

  String getCloudCoverage() =>
      cloudCoverage != null ? "&MAXCC=${this.cloudCoverage}" : "";

  String getNasaRequestUrl() {
    return "https://wvs.earthdata.nasa.gov/api/v1/snapshot?REQUEST=GetSnapshot&LAYERS=${this.layers.join(',')}&CRS=EPSG:4326&TIME=${this.time}&BBOX=${this.getBoundaries()}&FORMAT=image/jpeg&WIDTH=${this.getResolutions()["width"]}&HEIGHT=${this.getResolutions()["height"]}&AUTOSCALE=FALSE";
  }

  String getSentinelHubRequestUrl() {
    return "https://services.sentinel-hub.com/ogc/wms/3566872f-a627-4bd0-b410-c06dc82fe1ff?REQUEST=GetMap&CRS=EPSG:4326&BBOX=${this.getBoundaries()}&LAYERS=${this.layers.join(',')}&WIDTH=${this.getResolutions()["width"]}&HEIGHT=${this.getResolutions()["height"]}&FORMAT=image/jpeg&TIME=2016-03-29/${this.time}${this.getCloudCoverage()}";
  }

  String getCopernicusRequestUrl() {
    return "https://scihub.copernicus.eu/dhus/search?q=footprint:%22Intersects(POLYGON((${this.getBoundaries()})))%22&URL=https://services.sentinel-hub.com/ogc/wms/3566872f-a627-4bd0-b410-c06dc82fe1ff?REQUEST=GetMap&CRS=EPSG:4326&BBOX=${this.getBoundaries()}&LAYERS=${this.layers.join(',')}&WIDTH=${this.getResolutions()["width"]}&HEIGHT=${this.getResolutions()["height"]}&FORMAT=image/jpeg&TIME=2016-03-29/${this.time}${this.getCloudCoverage()}";
  }
}
