import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storage_space/storage_space.dart';
import 'package:syncmov/state.dart';

// final cwdProvider = StateProvider<String>((ref) {
//   return ref.watch(libraryProvider)!.path;
// });

final dirlistProvider = FutureProvider<List<String>>((ref) async {
  final library = ref.watch(libraryProvider);
  final sftp = ref.watch(librarySftpProvider);
  // final cwd = ref.watch(cwdProvider);

  if (library == null || !sftp.hasValue) {
    return [];
  }

  final list = (await sftp.value!.listdir(library.path))
      .map((e) => e.filename)
      .where((name) => !name.startsWith("."))
      .toList();

  list.sort();

  return list;
});

// get the total size of all files in library.path / dir
final dirsizeProvider = FutureProvider.family<int, String>((ref, dir) async {
  final library = ref.watch(libraryProvider);
  final sftp = ref.watch(librarySftpProvider);

  if (library == null || !sftp.hasValue) {
    return 0;
  }

  final list = await sftp.value!.listdir("${library.path}/$dir");

  int size = 0;
  for (final item in list) {
    size += (await sftp.value!.stat("${library.path}/$dir/${item.filename}"))
            .size ??
        0;
  }

  return size;
});

class DownloadPage extends ConsumerWidget {
  const DownloadPage({
    super.key,
  });

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => const DownloadPage(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final library = ref.watch(libraryProvider)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(library.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: ref.watch(dirlistProvider).when(
                  data: (list) => Scrollbar(
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return _Folder(item);
                      },
                    ),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stack) => const Center(
                    child: Text("Error"),
                  ),
                ),
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: const SafeArea(child: _Storage()),
          ),
        ],
      ),
    );
  }
}

class _Folder extends ConsumerWidget {
  final String name;

  const _Folder(
    this.name, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(name),
      subtitle: ref.watch(dirsizeProvider(name)).when(
            data: (size) {
              final gb = size / 1024 / 1024 / 1024;
              final nice = gb.toStringAsFixed(1);
              return Text("$nice GB");
            },
            loading: () => const Text("Loading..."),
            error: (error, stack) => const Text("Error"),
          ),
      onTap: () {},
    );
  }
}

class _Storage extends ConsumerWidget {
  const _Storage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spaceInfo =
        getStorageSpace(lowOnSpaceThreshold: 1, fractionDigits: 1);

    return FutureBuilder<StorageSpace>(
      future: spaceInfo,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;

          return Column(
            children: [
              LinearProgressIndicator(
                value: data.usageValue,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(data.usedSize),
                    Text(data.totalSize),
                  ],
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
