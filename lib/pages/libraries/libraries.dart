import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncmov/models/library.dart';
import 'package:syncmov/pages/library/library.dart';
import 'package:syncmov/preferences.dart';
import 'package:syncmov/state.dart';

import 'add.dart';

class LibrariesPage extends ConsumerWidget {
  const LibrariesPage({super.key});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const LibrariesPage());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Libraries"),
      ),
      body: StreamBuilder<List<Library>>(
        stream: Preferences.libraries(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final libraries = snapshot.data!;

          return ListView.builder(
            itemCount: libraries.length,
            itemBuilder: (context, index) {
              final library = libraries[index];

              return ListTile(
                title: Text(library.name),
                subtitle: Text(library.host),
                onTap: () {
                  ref.read(libraryProvider.notifier).state = library;
                  Navigator.push(context, LibraryPage.route());
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, LibraryAddPage.route());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
