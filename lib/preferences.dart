import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:syncmov/models/library.dart';

class Preferences {
  static const String _librariesKey = "libraries";

  static Stream<List<Library>> libraries() async* {
    final prefs = await StreamingSharedPreferences.instance;
    var stream = prefs.getStringList(_librariesKey, defaultValue: []);

    await for (final libraries in stream) {
      yield libraries.map((e) => Library.fromJson(e)).toList();
    }
  }

  static Future<void> addLibrary(Library library) async {
    final prefs = await StreamingSharedPreferences.instance;

    final libraries =
        prefs.getStringList(_librariesKey, defaultValue: []).getValue();

    libraries.add(library.toJson());

    prefs.setStringList(_librariesKey, libraries);
  }
}
