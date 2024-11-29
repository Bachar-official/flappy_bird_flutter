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
    priority = 3;
    add(Cloud(yPos: rnd.nextDouble() * Config.cloudHeight));
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
