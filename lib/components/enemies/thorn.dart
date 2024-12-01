import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy_bird/components/bird.dart';
import 'package:flappy_bird/components/enemies/utils/thorn_data.dart';
import 'package:flappy_bird/game/config.dart';
import 'package:flappy_bird/game/game.dart';
import 'package:flutter/material.dart';

class Thorn extends SpriteComponent
    with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  final ThornData thorn;

  Thorn({required this.thorn});

  @override
  Future<void> onLoad() async {
    final image = game.images.fromCache('block.png');
    sprite = Sprite(image);
    size.x = thorn.duration * Config.gameSpeed;
    var ySize = Config.groundHeight(gameRef) / 6;
    size.y = ySize;
    position.y = Config.getHeightPercentage(gameRef, thorn.y.toDouble());
    // position.x = gameRef.size.x;
    position.x = Config.getInitialPosition(game, thorn.time);

    // Создаем TextPaint для рендеринга текста
    final textPaint = TextPaint(
      style: TextStyle(
        fontSize: ySize / 2,
        color: Colors.black,
      ),
    );

    // Создаем TextComponent как дочерний элемент
    final text = TextComponent(
      text: thorn.label,
      anchor: Anchor.center,
      textRenderer: textPaint,
    );

    // Устанавливаем позицию текста в центре Thorn компонента
    text.position = size / 2; // Центрирование текста

    // Добавляем текст как дочерний компонент Thorn
    add(text);
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= Config.gameSpeed * dt;

    if (position.x < -(game.size.x + thorn.duration)) {
      removeFromParent();
      game.remove(this);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Bird) {
      removeFromParent();
      game.remove(this);
    }
  }
}
