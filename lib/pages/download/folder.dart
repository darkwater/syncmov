import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncmov/pages/download/download.dart';
import 'package:syncmov/state.dart';

class DownloadFolderPage extends ConsumerWidget {
  final String dir;

  const DownloadFolderPage({Key? key, required this.dir}) : super(key: key);

  static Route route(String dir) {
    return MaterialPageRoute<void>(
      builder: (_) => DownloadFolderPage(dir: dir),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final library = ref.watch(libraryProvider)!;
    final path = "${library.path}/$dir";

    return Scaffold(
      appBar: AppBar(
        title: Text(dir),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ref.watch(dirlistProvider(path)).when(
                data: (list) => Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final name = list[index];
                      return ListTile(
                        title: Text(name),
                      );
                    },
                  ),
                ),
                loading: () => const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (e, s) => const Expanded(
                  child: Center(
                    child: Text("Error"),
                  ),
                ),
              ),
          Container(
            color: Theme.of(context).cardColor,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ElevatedButton(
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "Download",
                          textScaleFactor: 1.2,
                        ),
                      ),
                      onPressed: () async {
                        final sftp = ref.read(librarySftpProvider).value!;
                        final files = await sftp.listdir(path);
                        final localDir =
                            "${(await getApplicationSupportDirectory()).path}/$dir";

                        for (final file in files) {
                          final remotePath = "$path/${file.filename}";
                          final localFile = File("$localDir/${file.filename}");

                          if (true || !await localFile.exists()) {
                            final remoteFile = await sftp.open(remotePath);

                            await localFile.create(recursive: true);
                            final io = await localFile.open(
                              mode: FileMode.write,
                            );
                            await for (final chunk in remoteFile.read()) {
                              await io.writeFrom(chunk);
                              print(chunk.lengthInBytes);
                            }
                            await io.close();
                          }
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
