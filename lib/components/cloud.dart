import 'package:flame/components.dart';
import 'package:flappy_bird/game/game.dart';

class Cloud extends SpriteComponent with HasGameReference<FlappyBirdGame> {
  @override
  final double height;

  Cloud({required this.height});

  @override
  void onLoad() {
    sprite = Sprite(game.images.fromCache('cloud.png'));
    size = Vector2(70, 50);
    position = Vector2(game.size.x, height);
    priority = 3;
  }
}