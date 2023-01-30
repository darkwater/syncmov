import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncmov/pages/download/download.dart';
import 'package:syncmov/state.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({
    super.key,
  });

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => const LibraryPage(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final library = ref.watch(libraryProvider)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(library.name),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text("Download"),
            onTap: () => Navigator.push(context, DownloadPage.route()),
          ),
          ListTile(
            leading: const Icon(Icons.play_circle_outline),
            title: const Text("Host"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.group),
            title: const Text("Join"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
