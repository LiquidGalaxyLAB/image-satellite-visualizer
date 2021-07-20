import 'package:geodesy/geodesy.dart';

class ImageRequest {
  final Geodesy geodesy = Geodesy();
  final List<String> layers;
  final String time;
  final Map<String, double> bbox;

  ImageRequest({
    required this.layers,
    required this.time,
    required this.bbox,
  });

  Map<String, String> getResolutions() {
    int height = (geodesy.distanceBetweenTwoGeoPoints(
                LatLng(this.bbox['lat1']!, this.bbox['lon1']!),
                LatLng(this.bbox['lat2']!, this.bbox['lon1']!)) /
            1000)
        .round();
    int width = (geodesy.distanceBetweenTwoGeoPoints(
                LatLng(this.bbox['lat1']!, this.bbox['lon1']!),
                LatLng(this.bbox['lat1']!, this.bbox['lon2']!)) /
            1000)
        .round();
    return {
      'height': height.toString(),
      'width': width.toString(),
    };
  }

  String getBoundaries() =>
      '${this.bbox['lat1']},${this.bbox['lon1']},${this.bbox['lat2']},${this.bbox['lon2']}';

  String getNasaRequestUrl() {
    return "https://wvs.earthdata.nasa.gov/api/v1/snapshot?REQUEST=GetSnapshot&LAYERS=${this.layers.join(',')}&CRS=EPSG:4326&TIME=${this.time}&BBOX=${this.getBoundaries()}&FORMAT=image/jpeg&WIDTH=${this.getResolutions()["width"]}&HEIGHT=${this.getResolutions()["height"]}&AUTOSCALE=FALSE";
  }

  String getSentinelHubRequestUrl() {
    return "https://services.sentinel-hub.com/ogc/wms/b54cb4a9-dbfc-4953-a1bf-12d6819d756b?REQUEST=GetMap&CRS=EPSG:4326&BBOX=${this.getBoundaries()}&LAYERS=${this.layers.join(',')}&WIDTH=${this.getResolutions()["width"]}&HEIGHT=${this.getResolutions()["height"]}&FORMAT=image/jpeg&TIME=2016-03-29/${this.time}&MAXCC=20";
  }

  String getCopernicusRequestUrl() {
    return "https://scihub.copernicus.eu/dhus/search?q=footprint:%22Intersects(POLYGON((${this.getBoundaries()})))%22&URL=https://services.sentinel-hub.com/ogc/wms/b54cb4a9-dbfc-4953-a1bf-12d6819d756b?REQUEST=GetMap&CRS=EPSG:4326&BBOX=${this.getBoundaries()}&LAYERS=${this.layers.join(',')}&WIDTH=${this.getResolutions()["width"]}&HEIGHT=${this.getResolutions()["height"]}&FORMAT=image/jpeg&TIME=2016-03-29/${this.time}";
  }
}
