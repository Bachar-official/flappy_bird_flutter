import 'dart:convert';
import 'dart:io';

class ThornData {
  final double time;
  final double height;
  final bool bottom;

  const ThornData(
      {required this.time, required this.height, required this.bottom});

  factory ThornData.fromJson(Map<String, dynamic> json) => ThornData(
      time: json['time'], height: json['height'], bottom: json['bottom']);
}

Future<List<ThornData>> loadThorns(String path) async {
  final jsonStrFile = File(path);
  final List<dynamic> data = json.decode(jsonStrFile.readAsStringSync());
  return data.map((e) => ThornData.fromJson(e)).toList();
}
