import 'dart:math' show cos, sqrt, asin;

class ImageRequest {
  final List<String> layers;
  final String time;
  final Map<String, double> bbox;

  ImageRequest({
    required this.layers,
    required this.time,
    required this.bbox,
  });

  double calculateDistance(lat1, long1, lat2, long2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 + 
          c(lat1 * p) * c(lat2 * p) * 
          (1 - c((long2 - long1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  Map<String, String> getResolutions() {
    
    return {
      'height': '',
      'width': '',
    };
  }

  String getRequestUrl() {
    return "https://wvs.earthdata.nasa.gov/api/v1/snapshot?REQUEST=GetSnapshot&LAYERS=${this.layers}&CRS=EPSG:4326&TIME=${this.time}&WRAP=DAY,DAY&BBOX=${this.bbox}&FORMAT=image/jpeg&WIDTH=${this.getResolutions()["width"]}&HEIGHT=${this.getResolutions()["height"]}&AUTOSCALE=FALSE";
  }
}
