import 'dart:math';

import 'package:flame/components.dart';
import 'package:flappy_bird/components/pipe.dart';
import 'package:flappy_bird/game.dart';
import 'package:flappy_bird/game/config.dart';

class PipeGroup extends PositionComponent with HasGameRef<FlappyBirdGame> {
  PipeGroup();

  final rnd = Random();

  @override
  Future<void> onLoad() async {
    position.x = gameRef.size.x;
    final heightMinusGround = gameRef.size.y - Config.groundHeight;
    final spacing = 100 + rnd.nextDouble() * (heightMinusGround / 4);
    final centerY = spacing + rnd.nextDouble() * (heightMinusGround - spacing);
    addAll(
      [
        Pipe(pipePosition: PipePosition.top, height: centerY - spacing / 2),
        Pipe(pipePosition: PipePosition.bottom, height: heightMinusGround - (centerY + spacing / 2),),
      ]
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= Config.gameSpeed * dt;

    if (position.x < -150) {
      removeFromParent();
    }
  }
}