import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flappy_bird/game.dart';
import 'package:flappy_bird/game/config.dart';
import 'package:flutter/animation.dart';

class Bird extends SpriteAnimationComponent
    with HasGameReference<FlappyBirdGame> {
  bool isAnimating = false;
  int score = 0;

  late SpriteAnimation idleAnimation;
  late SpriteAnimation flyAnimation;

  Bird({required super.position})
      : super(size: Vector2.all(128), anchor: Anchor.center);

  Vector2 velocity = Vector2.zero();
  double jumpStrength = -Config.gravity;

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

    add(CircleHitbox());
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
    add(
      MoveByEffect(
        Vector2(0, -Config.gravity),
        EffectController(duration: 0.2, curve: Curves.decelerate),
      ),
    );
    velocity.y = jumpStrength;
    playAnimation();
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += Config.birdVelocity * dt;
  }
}
