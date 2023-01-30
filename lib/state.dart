import 'package:dartssh2/dartssh2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/library.dart';

final libraryProvider = StateProvider<Library?>((ref) => null);
final librarySftpProvider = FutureProvider<SftpClient?>((ref) async {
  final library = ref.watch(libraryProvider);
  if (library == null) {
    return null;
  }

  return await library.connect();
});
