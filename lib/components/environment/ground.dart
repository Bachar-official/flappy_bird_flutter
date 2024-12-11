import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy_bird/game/game.dart';
import 'package:flappy_bird/game/config.dart';

class Ground extends SpriteComponent with HasGameRef<FlappyBirdGame> {
  final Config config;
  Ground({required this.config});

  @override
  Future<void> onLoad() async {
    sprite = Sprite(game.images.fromCache('ground.png'));
    size = Vector2(608, config.groundHeight(gameRef) / 5);
    add(RectangleHitbox(
      size: Vector2(608, config.groundHeight(gameRef) - 100),
    ));
  }
}
