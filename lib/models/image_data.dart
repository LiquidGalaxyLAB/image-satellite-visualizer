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

  toString() => "imagePath: ${this.imagePath}\n title: ${this.title}\n description: ${this.description}\n coordinates: ${this.coordinates}";
}
