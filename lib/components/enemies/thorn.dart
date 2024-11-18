import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy_bird/components/enemies/thorn_position.dart';
import 'package:flappy_bird/game/config.dart';
import 'package:flappy_bird/game/game.dart';

class Thorn extends SpriteComponent with HasGameRef<FlappyBirdGame> {
  @override
  final double height;
  final ThornPosition thornPosition;

  Thorn({required this.height, required this.thornPosition});

  @override
  Future<void> onLoad() async {
    position.x = gameRef.size.x;
    final thorn = gameRef.images.fromCache('thorn.png');
    final thornRotated = gameRef.images.fromCache('thorn-rotated.png');
    size = Vector2(50, height);

    switch (thornPosition) {
      case ThornPosition.top:
        position.y = Config.ceilingHeight;
        sprite = Sprite(thornRotated);
        break;
      case ThornPosition.bottom:
        position.y = gameRef.size.y - size.y - Config.groundHeight;
        sprite = Sprite(thorn);
        break;
    }
    priority = 2;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= Config.gameSpeed * dt;

    if (position.x < -(game.size.x + 50)) {
      removeFromParent();
    }
  }
}
