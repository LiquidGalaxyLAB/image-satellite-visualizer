// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ImageDataAdapter extends TypeAdapter<ImageData> {
  @override
  final int typeId = 0;

  @override
  ImageData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ImageData(
      imagePath: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      coordinates: (fields[3] as Map).cast<String, String>(),
      date: fields[4] as DateTime,
      api: fields[5] as String,
      layer: fields[6] as String,
      layerDescription: fields[7] as String,
      colors: (fields[8] as List)
          .map((dynamic e) => (e as Map).cast<String, String>())
          .toList(),
      demo: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ImageData obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.imagePath)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.coordinates)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.api)
      ..writeByte(6)
      ..write(obj.layer)
      ..writeByte(7)
      ..write(obj.layerDescription)
      ..writeByte(8)
      ..write(obj.colors)
      ..writeByte(9)
      ..write(obj.demo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
