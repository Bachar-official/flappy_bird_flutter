import 'dart:math';

import 'package:flame/components.dart';
import 'package:flappy_bird/components/cloud.dart';
import 'package:flappy_bird/game/config.dart';
import 'package:flappy_bird/game/game.dart';

class CloudGroup extends PositionComponent with HasGameRef<FlappyBirdGame> {
  CloudGroup();

  final rnd = Random();

  @override
  void onLoad() {
    position.x = gameRef.size.x;
    final heightMinusClouds = gameRef.size.y - Config.cloudHeight;
    priority = 3;
    add(Cloud(height: rnd.nextDouble() * Config.cloudHeight));
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= Config.gameSpeed * dt;

    if (position.x < -(gameRef.size.x + 50)) {
      removeFromParent();
    }
  }
}