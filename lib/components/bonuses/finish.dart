import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy_bird/game/config.dart';
import 'package:flappy_bird/game/game.dart';

class Finish extends SpriteComponent with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  Finish();

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('finish.png');
    final ySize = (gameRef.size.y - Config.groundHeight - Config.ceilingHeight);
    final xSize = ySize / 4;
    size = Vector2(xSize, ySize);
    position.x = gameRef.size.x;
    position.y = Config.ceilingHeight;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= Config.gameSpeed * dt;
  }
}