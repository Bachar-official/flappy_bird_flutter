import 'dart:convert';
import 'dart:io';

import 'package:flappy_bird/components/bonuses/utils/hour_data.dart';
import 'package:flappy_bird/components/enemies/utils/thorn_data.dart';

class Level {
  final List<ThornData> thorns;
  final List<HourData> hours;
  final double finishAt;

  const Level(
      {required this.thorns, required this.hours, required this.finishAt});

  factory Level.fromJson(Map<String, dynamic> json) {
    if (json['thorns'] == null ||
        json['hours'] == null ||
        json['finishAt'] == null) {
      throw const FormatException('Required field is missing');
    }
    if (json['thorns'] is! List ||
        json['hours'] is! List ||
        json['finishAt'] is! double) {
      throw const FormatException('Invalid thorns or hours format');
    }
    var thornsJson = List<Map<String, dynamic>>.from(json['thorns']);
    var hoursJson = List<Map<String, dynamic>>.from(json['hours']);
    return Level(
      thorns: (thornsJson).map((e) => ThornData.fromJson(e)).toList(),
      hours: (hoursJson).map((e) => HourData.fromJson(e)).toList(),
      finishAt: json['finishAt'],
    );
  }
}

Future<Level> loadLevel(String path) async =>
    Level.fromJson(json.decode(await File(path).readAsString()));
