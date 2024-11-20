import 'dart:convert';
import 'dart:io';

import 'package:flappy_bird/entity/song.dart';

Future<List<File>> getJsonFiles() async {
  final dir = Directory('./');
  if (dir.existsSync()) {
    return dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.json'))
        .toList();
  }
  return [];
}

Future<List<Song>> getSongs() async {
  final files = await getJsonFiles();
  return files.map((file) {
    final json = file.readAsStringSync();
    final map = jsonDecode(json) as Map<String, dynamic>;
    return Song.fromFile(file.uri.pathSegments.last, map);
  }).toList();
}
