import 'dart:convert';
import 'dart:io';

import 'package:flappy_bird/game/game.dart';

class Config {
  final double gameSpeed;
  final double cloudHeight;
  final double birdVelocity;
  final double gravity;
  final double ceilingHeight;
  final int startDelay;

  const Config({required this.birdVelocity, required this.ceilingHeight, required this.cloudHeight, required this.gameSpeed, required this.gravity, required this.startDelay});

  factory Config.fromConfigJson(Map<String, dynamic> json) => Config(
    gameSpeed: json['gameSpeed'],
    cloudHeight: json['cloudHeight'],
    birdVelocity: json['birdVelocity'],
    gravity: json['gravity'],
    ceilingHeight: json['ceilingHeight'],
    startDelay: json['startDelay'],
  );

  static Future<Config> getConfigFromFile() async {
    final configFile = File('config.conf');
    if (!await configFile.exists()) {
      throw Exception('File not exists');
    }
    return Config.fromConfigJson(jsonDecode(configFile.readAsStringSync()));
  }

  double groundHeight(FlappyBirdGame game) =>
      game.size.y - game.size.y / 5 - ceilingHeight;
  double getHeightPercentage(FlappyBirdGame game, double percentage) {
    final availableHeight = groundHeight(game) - ceilingHeight;
    // Инвертируем процент так, чтобы 0% был на уровне groundHeight, а 100% на уровне ceilingHeight.
    return groundHeight(game) - (availableHeight / 100 * percentage);
  }

  double getHeightAbsolute(
      FlappyBirdGame game, double y, double objectHeight) {
    final double ground = groundHeight(game);
    final double availableHeight = ground - ceilingHeight;

    // Корректируем позицию Y, учитывая, что anchor у птицы в центре
    final double adjustedY = y - objectHeight / 2;

    // Рассчитываем процент: 0% на уровне groundHeight, 100% на уровне ceilingHeight
    final double relativeHeight = (ground - adjustedY) / availableHeight;

    // Преобразуем в проценты
    return relativeHeight * 100;
  }

  /// Рассчитываем позицию X для входа в игру, чтобы объекты появлялись в начале игры
  double getInitialPosition(FlappyBirdGame game, double objectTime) {
    return (objectTime - game.time) * gameSpeed;
  }
}
