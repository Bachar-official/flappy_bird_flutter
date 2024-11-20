import 'dart:convert';
import 'dart:io';

import 'package:flappy_bird/components/bonuses/utils/hour_data.dart';
import 'package:flappy_bird/components/enemies/utils/thorn_data.dart';
import 'package:flappy_bird/components/levels/words.dart';

class Level {
  final List<ThornData> thorns;
  final List<HourData> hours;
  final double finishAt;
  final String music;
  final List<Words> words;

  const Level(
      {required this.thorns,
      required this.hours,
      required this.finishAt,
      required this.music,
      required this.words});

  factory Level.fromJson(Map<String, dynamic> json) {
    if (json['thorns'] == null ||
        json['hours'] == null ||
        json['finishAt'] == null ||
        json['music'] == null ||
        json['words'] == null) {
      throw const FormatException('Required field is missing');
    }
    if (json['thorns'] is! List ||
        json['hours'] is! List ||
        json['finishAt'] is! double ||
        json['music'] is! String ||
        json['words'] is! List) {
      throw const FormatException('Invalid thorns or hours format');
    }
    var thornsJson = List<Map<String, dynamic>>.from(json['thorns']);
    var hoursJson = List<Map<String, dynamic>>.from(json['hours']);
    var wordsJson = List<Map<String, dynamic>>.from(json['words']);
    return Level(
      thorns: thornsJson.map((e) => ThornData.fromJson(e)).toList(),
      hours: hoursJson.map((e) => HourData.fromJson(e)).toList(),
      words: wordsJson.map((e) => Words.fromJson(e)).toList(),
      finishAt: json['finishAt'],
      music: json['music'],
    );
  }
}

Future<Level> loadLevel(String path) async =>
    Level.fromJson(json.decode(await File(path).readAsString()));
