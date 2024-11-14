import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy_bird/game/game.dart';
import 'package:flappy_bird/game/config.dart';

enum PipePosition { top, bottom }

class Pipe extends SpriteComponent with HasGameReference<FlappyBirdGame> {
  @override
  final double height;
  final PipePosition pipePosition;

  Pipe({required this.height, required this.pipePosition});

  @override
  FutureOr<void> onLoad() async {
    final pipe = game.images.fromCache('pipe.png');
    final pipeRotated = game.images.fromCache('pipe-rotated.png');
    size = Vector2(80, height);

    switch (pipePosition) {
      case PipePosition.top:
        position.y = 0;
        sprite = Sprite(pipeRotated);
        break;

      case PipePosition.bottom:
        position.y = game.size.y - size.y - Config.groundHeight;
        sprite = Sprite(pipe);
        break;
    }
    priority = 2;
    add(RectangleHitbox());
  }
}
