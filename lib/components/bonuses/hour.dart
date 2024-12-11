import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flappy_bird/components/bird.dart';
import 'package:flappy_bird/components/bonuses/utils/hour_data.dart';
import 'package:flappy_bird/game/config.dart';
import 'package:flappy_bird/game/game.dart';
import 'package:flutter/material.dart';

class Hour extends SpriteComponent
    with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  final HourData data;
  final Config config;

  Hour({required this.data, super.key, required this.config});

  @override
  Future<void> onLoad() async {
    final img15 = gameRef.images.fromCache('hours-15.png');
    final img30 = gameRef.images.fromCache('hours-30.png');
    final img45 = gameRef.images.fromCache('hours-45.png');
    final img60 = gameRef.images.fromCache('hours-60.png');
    final hourSize = config.groundHeight(gameRef) / 15;
    size = Vector2(hourSize, hourSize);
    position.x = config.getInitialPosition(game, data.time);
    position.y = config.getHeightPercentage(game, data.pos);

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

  void flyAway() {
    final screenWidth = gameRef.size.x;
    final targetX = screenWidth * 0.75; // 75% от ширины экрана
    final targetY = -size.y; // Улетает за верх экрана

    // Анимация перемещения
    add(
      MoveEffect.to(
        Vector2(targetX, targetY), // Целевая позиция
        EffectController(
          duration: 0.5, // Полсекунды
          curve: Curves.linear, // Линейное движение
        ),
        onComplete: () {
          // Удаление компонента после завершения движения
          removeFromParent();
        },
      ),
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Bird) {
      if (game.score >= 480) {
        game.score += 2 * data.score;
      } else {
        game.score += data.score;
      }
      gameRef.currentScore.scored();
      flyAway();
    }
  }

  @override
  void update(dt) {
    super.update(dt);
    position.x -= config.gameSpeed * dt;

    if (position.x < -(game.size.x + size.x)) {
      removeFromParent();
      game.remove(this);
    }
  }
}
