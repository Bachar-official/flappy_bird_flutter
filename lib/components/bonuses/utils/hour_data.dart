import 'dart:convert';
import 'dart:io';

class HourData {
  final double time;
  final int score;
  final double pos;

  const HourData({required this.score, required this.pos, required this.time});

  factory HourData.fromJson(Map<String, dynamic> json) => HourData(
        score: json['score'],
        pos: json['pos'],
        time: json['time'],
      );
}

Future<List<HourData>> loadHours(String path) async {
  final jsonStrFile = File(path);
  final List<dynamic> data = json.decode(jsonStrFile.readAsStringSync());
  return data.map((e) => HourData.fromJson(e)).toList();
}
