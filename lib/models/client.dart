import "dart:io";

import "package:image_satellite_visualizer/models/image_data.dart";
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

  void createClient() async {
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

      await client.sftpUpload(
        path: image.imagePath,
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

      await client.execute('echo "http://lg1:81/${image.getFileName()}.kml" >> /var/www/html/image_satellite_visualizer.txt');
      await client.execute('cat /var/www/html/image_satellite_visualizer.txt >> /var/www/html/kmls.txt');
    } catch (e) {
      print("error: $e");
    }
  }
}
