import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Journal photos, kept in the app's private storage (not the public gallery).
/// The database stores only the file name, so paths survive app updates.
class JournalPhotos {
  JournalPhotos._(this.dir);
  final Directory dir;

  static Future<JournalPhotos> open() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/journal_photos');
    await dir.create(recursive: true);
    return JournalPhotos._(dir);
  }

  /// The photo file for [name], or null if none is set or it's missing (for
  /// example after restoring a backup, which doesn't include photos).
  File? file(String name) {
    if (name.isEmpty) return null;
    final f = File('${dir.path}/$name');
    return f.existsSync() ? f : null;
  }

  /// Takes a photo with the phone's camera app or picks one from the gallery,
  /// and copies it here. Returns the new file name, or null if cancelled.
  /// The camera app does the capturing, so Chitah needs no camera permission.
  Future<String?> pick(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source, maxWidth: 1600, imageQuality: 82);
    if (picked == null) return null;
    final name = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
    await File(picked.path).copy('${dir.path}/$name');
    return name;
  }

  Future<void> delete(String name) async {
    if (name.isEmpty) return;
    final f = File('${dir.path}/$name');
    if (await f.exists()) await f.delete();
  }

  /// Removes every journal photo (used by "Erase everything").
  Future<void> deleteAll() async {
    if (await dir.exists()) await dir.delete(recursive: true);
    await dir.create(recursive: true);
  }
}
