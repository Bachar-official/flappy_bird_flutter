import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy_bird/game/game.dart';
import 'package:flappy_bird/game/config.dart';

class Ground extends SpriteComponent with HasGameRef<FlappyBirdGame> {
  Ground();

  @override
  Future<void> onLoad() async {
    sprite = Sprite(game.images.fromCache('ground.png'));
    size = Vector2(608, Config.groundHeight);
    add(RectangleHitbox());
  }
}
