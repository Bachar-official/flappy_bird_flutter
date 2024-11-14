import 'package:flame/components.dart';
import 'package:flappy_bird/components/ground.dart';
import 'package:flappy_bird/game.dart';
import 'package:flappy_bird/game/config.dart';

class GroundGroup extends PositionComponent with HasGameRef<FlappyBirdGame> {
  GroundGroup();

  @override
  Future<void> onLoad() async {
    add(Ground());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= Config.gameSpeed * dt;

    if (position.x < -(gameRef.size.x + 50)) {
      removeFromParent();
    }
  }
}