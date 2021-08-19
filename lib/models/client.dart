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
  ImageData? image;

  Client({
    required this.ip,
    required this.username,
    required this.password,
    this.image,
  });

  void closeDemos() async {
    try {
      var client = new SSHClient(
        host: this.ip,
        port: 22,
        username: this.username,
        passwordOrKey: this.password,
      );

      await client.connect();
      await client.connectSFTP();

      await client.execute('sshpass -p lq ssh lg4 "pkill pqiv"');
    } catch (e) {
      print("error: $e");
    }
  }

  void sendLogo() async {
    try {
      var client = new SSHClient(
        host: this.ip,
        port: 22,
        username: this.username,
        passwordOrKey: this.password,
      );

      String openLogoKML = '''
<?xml version="1.0" encoding="UTF-8"?>
  <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
    <Document>
      <name>Ras-logos</name>
        <Folder>
        <name>Logos</name>
        <ScreenOverlay>
        <name>Logo</name>
        <Icon>
        <href>https://i.imgur.com/CVDtOXm.png</href>
        </Icon>
        <overlayXY x="0" y="1" xunits="fraction" yunits="fraction"/>
        <screenXY x="0.02" y="0.95" xunits="fraction" yunits="fraction"/>
        <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
        <size x="0.4" y="0.2" xunits="fraction" yunits="fraction"/>
        </ScreenOverlay>
        </Folder>
    </Document>
  </kml>
    ''';
    
      await client.connect();

      await client.execute("echo '$openLogoKML' > /var/www/html/kml/slave_4.kml");
    } catch (e) {
      print("error: $e");
    }
  }

  void sendImage(String syncFile) async {
    try {
      var client = new SSHClient(
        host: this.ip,
        port: 22,
        username: this.username,
        passwordOrKey: this.password,
      );

      File file = await this.image!.generateKml();

      await client.connect();
      await client.execute("> /var/www/html/kmls.txt");
      await client.connectSFTP();

      String finalImagePath;

      if (image!.demo) {
        Directory documentDirectory = await getApplicationDocumentsDirectory();
        File demoImage = new File(
            path.join(documentDirectory.path, '${image!.getFileName()}.jpeg'));
        var byteData = await rootBundle.load(image!.imagePath);
        demoImage.writeAsBytesSync(byteData.buffer
            .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
        finalImagePath = demoImage.path;
      } else {
        finalImagePath = image!.imagePath;
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

      if (this.image!.selected)
        await client
            .execute('echo "flytoview=${generateFlyTo()}" > /tmp/query.txt');
    } catch (e) {
      print("error: $e");
    }
  }

  void cleanKML() async {
    try {
      var client = new SSHClient(
        host: this.ip,
        port: 22,
        username: this.username,
        passwordOrKey: this.password,
      );

      await client.connect();
      await client.execute("> /var/www/html/kmls.txt");
    } catch (e) {
      print("error: $e");
    }
  }

  Future<void> checkConnection() async {
    var client = new SSHClient(
      host: this.ip,
      port: 22,
      username: this.username,
      passwordOrKey: this.password,
    );

    await client.connect();
  }

  String generateFlyTo() {
    return '<LookAt><longitude>${midpoint(this.image?.coordinates['minLon'], this.image?.coordinates['maxLon'])}</longitude><latitude>${midpoint(this.image?.coordinates['minLat'], this.image?.coordinates['maxLat'])}</latitude><range>1000000</range><tilt>0</tilt><gx:altitudeMode>relativeToGround</gx:altitudeMode></LookAt>';
  }

  String midpoint(String? a, String? b) =>
      ((double.parse(a!) + double.parse(b!)) / 2).toString();

  void deleteImages(String file, String syncFile) async {
    try {
      var client = new SSHClient(
        host: this.ip,
        port: 22,
        username: this.username,
        passwordOrKey: this.password,
      );

      await client.connect();
      await client.connectSFTP();

      await client.sftpRm("/var/www/html/$file.jpeg");
      await client.sftpRm("/var/www/html/$file.kml");
      await client.execute('echo "$syncFile" > /var/www/html/kmls.txt');
    } catch (e) {
      print("error: $e");
    }
  }
}
