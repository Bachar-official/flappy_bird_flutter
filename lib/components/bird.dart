import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy_bird/game/game.dart';
import 'package:flappy_bird/game/config.dart';
import 'package:flutter/animation.dart';

import 'ground.dart';
import 'pipe.dart';

class Bird extends SpriteAnimationComponent
    with HasGameReference<FlappyBirdGame>, CollisionCallbacks {
  bool isAnimating = false;

  late SpriteAnimation idleAnimation;
  late SpriteAnimation flyAnimation;

  Bird({required super.position})
      : super(size: Vector2.all(128), anchor: Anchor.center);

  Vector2 velocity = Vector2.zero();
  double jumpStrength = -400; // Увеличиваем силу прыжка
  bool isOnGround = false;

  @override
  void onLoad() {
    final spriteSheet = game.images.fromCache('bird.png');

    flyAnimation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.04,
        textureSize: Vector2(349, 305),
      ),
    );

    idleAnimation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 1,
        textureSize: Vector2(349, 305),
      ),
    );

    flyAnimation.loop = false;
    animation = idleAnimation;
    size = Vector2(50, 40);

    add(CircleHitbox(anchor: Anchor.bottomRight));
  }

  void playAnimation() {
    isAnimating = true;
    animation = flyAnimation;
    animationTicker?.onComplete = () => stopAnimation();
  }

  void stopAnimation() {
    isAnimating = false;
    animation = idleAnimation;
  }

  void jump() {
    isOnGround = false;
    velocity.y =
        -Config.gravity; // Устанавливаем отрицательную скорость для прыжка
    playAnimation();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Применяем гравитацию
    velocity.y += Config.gravity * dt;
    position.y += velocity.y * dt;

    // Проверяем, не находится ли персонаж ниже уровня земли
    if (position.y >= game.size.y - Config.groundHeight - size.y / 2) {
      position.y = game.size.y - Config.groundHeight - size.y / 2;
      isOnGround = true;
      velocity.y = 0;
    }
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    if (other is Pipe) {
      game.overlays.add('gameOver');
      game.pauseEngine();
    }

    // Проверка коллизии с землёй
    if (other is Ground) {
      isOnGround = true;
      velocity.y = 0;
    }

    super.onCollision(points, other);
  }

  void reset() {
    position = Vector2(128, 0 + 128);
    isOnGround = false;
    velocity = Vector2.zero();
  }
}
