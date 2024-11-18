import 'dart:convert';
import 'dart:io';

class PipeData {
  final double time;
  final double height;
  final bool bottom;

  const PipeData(
      {required this.time, required this.height, required this.bottom});

  factory PipeData.fromJson(Map<String, dynamic> json) => PipeData(
      time: json['time'], height: json['height'], bottom: json['bottom']);
}

Future<List<PipeData>> loadPipes(String path) async {
  final jsonStrFile = File(path);
  final List<dynamic> data = json.decode(jsonStrFile.readAsStringSync());
  return data.map((e) => PipeData.fromJson(e)).toList();
}
