import "dart:io";

import 'package:flutter/services.dart';
import "package:image_satellite_visualizer/models/image_data.dart";
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import "package:ssh/ssh.dart";

class Client {
  final String ip;
  final String username;
  final String password;
  final ImageData image;

  Client({
    required this.ip,
    required this.username,
    required this.password,
    required this.image,
  });

  void sendImage(String syncFile) async {
    try {
      var client = new SSHClient(
        host: this.ip,
        port: 22,
        username: this.username,
        passwordOrKey: this.password,
      );

      File file = await this.image.generateKml();

      await client.connect();
      await client.execute("> /var/www/html/kmls.txt");
      await client.connectSFTP();

      String finalImagePath;

      if(image.demo) {
        Directory documentDirectory = await getApplicationDocumentsDirectory();
        File demoImage = new File(path.join(documentDirectory.path,
          '${image.getFileName()}.jpeg'));
        var byteData = await rootBundle.load(image.imagePath);
        demoImage.writeAsBytesSync(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
        finalImagePath = demoImage.path;
      } else {
        finalImagePath = image.imagePath;
      }

      await client.sftpUpload(
        path: finalImagePath,
        toPath: "/var/www/html",
        callback: (progress) {
          print("Sent $progress");
        },
      );

      await client.sftpUpload(
        path: file.path,
        toPath: "/var/www/html",
        callback: (progress) {
          print("Sent $progress");
        },
      );

      await client.execute('echo "$syncFile" > /var/www/html/kmls.txt');
    } catch (e) {
      print("error: $e");
    }
  }
}
