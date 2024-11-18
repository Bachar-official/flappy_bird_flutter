import 'package:flame/components.dart';
import 'package:flappy_bird/game/game.dart';

class Background extends SpriteComponent with HasGameRef<FlappyBirdGame> {
  Background();

  @override
  Future<void> onLoad() async {
    sprite = Sprite(game.images.fromCache('background.png'));
    size = gameRef.size;
    priority = -10;
  }
}