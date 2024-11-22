import 'package:flappy_bird/game/game.dart';

abstract class Config {
  static double groundHeight(FlappyBirdGame game) =>
      game.size.y - game.size.y / 5 - ceilingHeight;
  static double getHeightPercentage(FlappyBirdGame game, double percentage) =>
      groundHeight(game) - groundHeight(game) / 100 * percentage;
  static const gameSpeed = 200.0;
  static const pipeInterval = 1.5;
  static const cloudHeight = 150.0;
  static const birdVelocity = 450.0;
  static const gravity = 150.0;
  static const ceilingHeight = 50.0;
}
