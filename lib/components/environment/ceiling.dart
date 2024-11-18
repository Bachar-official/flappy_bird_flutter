import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy_bird/game/config.dart';
import 'package:flappy_bird/game/game.dart';

class Ceiling extends SpriteComponent with HasGameRef<FlappyBirdGame> {
  Ceiling();

  @override
  Future<void> onLoad() async {
    sprite = Sprite(game.images.fromCache('ceiling.png'));
    size = Vector2(50, Config.ceilingHeight);
    add(RectangleHitbox());
  }
}
