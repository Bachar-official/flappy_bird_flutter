import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy_bird/components/bird.dart';
import 'package:flappy_bird/components/bonuses/utils/hour_data.dart';
import 'package:flappy_bird/game/config.dart';
import 'package:flappy_bird/game/game.dart';

class Hour extends SpriteComponent
    with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  final HourData data;

  Hour({required this.data, super.key});

  @override
  Future<void> onLoad() async {
    final img15 = gameRef.images.fromCache('hours-15.png');
    final img30 = gameRef.images.fromCache('hours-30.png');
    final img45 = gameRef.images.fromCache('hours-45.png');
    final img60 = gameRef.images.fromCache('hours-60.png');
    final hourSize = Config.groundHeight(gameRef) / 15;
    size = Vector2(hourSize, hourSize);
    position.x = Config.getInitialPosition(game, data.time);
    position.y = Config.getHeightPercentage(game, data.pos);

    switch (data.score) {
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
    if (other is Bird) {
      game.score += data.score;
      removeFromParent();
      game.remove(this);
    }
  }

  @override
  void update(dt) {
    super.update(dt);
    position.x -= Config.gameSpeed * dt;

    if (position.x < -(game.size.x + size.x)) {
      removeFromParent();
      game.remove(this);
    }
  }
}
