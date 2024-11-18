import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy_bird/game/config.dart';
import 'package:flappy_bird/game/game.dart';

class Hour extends SpriteComponent
    with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  final int score;
  final double yPos;

  Hour({required this.score, required this.yPos});

  @override
  Future<void> onLoad() async {
    final img15 = gameRef.images.fromCache('hours-15.png');
    final img30 = gameRef.images.fromCache('hours-30.png');
    final img45 = gameRef.images.fromCache('hours-45.png');
    final img60 = gameRef.images.fromCache('hours-60.png');
    size = Vector2(50, 50);
    position.x = gameRef.size.x;
    position.y = yPos;

    switch (score) {
      case 30:
        sprite = Sprite(img30);
        break;
      case 45:
        sprite = Sprite(img45);
        break;
      case 60:
        sprite = Sprite(img60);
        break;
      case 15:
      default:
        sprite = Sprite(img15);
        break;
    }
    add(CircleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    removeFromParent();
  }

  @override
  void update(dt) {
    super.update(dt);
    position.x -= Config.gameSpeed * dt;

    // if (position.x < -(game.size.x + 50)) {
    //   removeFromParent();
    // }
  }
}
