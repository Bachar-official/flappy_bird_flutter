import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy_bird/game/config.dart';
import 'package:flappy_bird/game/game.dart';

class Finish extends SpriteComponent
    with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
      final Config config;
  Finish({required this.config});

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('finish.png');
    final ySize = config.groundHeight(game);
    final xSize = ySize / 4;
    size = Vector2(xSize, ySize);
    position.x =
        config.getInitialPosition(game, gameRef.level?.finishAt ?? 1) + xSize;
    position.y = config.ceilingHeight;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= config.gameSpeed * dt;
  }
}
