import 'package:flappy_bird/game/game.dart';

abstract class Config {
  static double groundHeight(FlappyBirdGame game) =>
      game.size.y - game.size.y / 5 - ceilingHeight;
  static double getHeightPercentage(FlappyBirdGame game, double percentage) {
    final availableHeight = groundHeight(game) - ceilingHeight;
    // Инвертируем процент так, чтобы 0% был на уровне groundHeight, а 100% на уровне ceilingHeight.
    return groundHeight(game) - (availableHeight / 100 * percentage);
  }

  static double getHeightAbsolute(
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
  static double getInitialPosition(FlappyBirdGame game, double objectTime) {
    return (objectTime - game.time) * gameSpeed;
  }

  static const gameSpeed = 200.0;
  static const pipeInterval = 1.5;
  static const cloudHeight = 150.0;
  static const birdVelocity = 450.0;
  static const gravity = 300.0;
  static const ceilingHeight = 50.0;
}
