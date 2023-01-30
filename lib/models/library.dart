import "dart:convert";

import 'package:dartssh2/dartssh2.dart';
import 'package:syncmov/preferences.dart';

class Library {
  final String id;
  final String name;
  final String host;
  final int port;
  final String username;
  final String password;
  final String path;

  const Library({
    required this.id,
    required this.name,
    required this.host,
    required this.port,
    required this.username,
    required this.password,
    required this.path,
  });

  factory Library.fromJson(String json) {
    final map = jsonDecode(json);
    return Library(
      id: map["id"],
      name: map["name"],
      host: map["host"],
      port: map["port"],
      username: map["username"],
      password: map["password"],
      path: map["path"],
    );
  }

  String toJson() {
    return jsonEncode({
      "id": id,
      "name": name,
      "host": host,
      "port": port,
      "username": username,
      "password": password,
      "path": path,
    });
  }

  Future<SftpClient> connect() async {
    final client = SSHClient(
      await SSHSocket.connect(host, port),
      username: username,
      onPasswordRequest: () => password,
    );

    return await client.sftp();
  }

  Future<String> test() async {
    final sftp = await connect();
    final items = await sftp.listdir(path);
    for (final item in items) {
      print(item.longname);
    }

    return "";
  }

  Future<void> save() async {
    Preferences.addLibrary(this);
  }
}
