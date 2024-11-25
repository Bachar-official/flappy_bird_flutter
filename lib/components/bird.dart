import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy_bird/components/bonuses/finish.dart';
import 'package:flappy_bird/components/enemies/thorn.dart';
import 'package:flappy_bird/components/environment/ceiling.dart';
import 'package:flappy_bird/game/game.dart';
import 'package:flappy_bird/game/config.dart';

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
  double get currentHeight => getCurrentHeight();

  double getCurrentHeight() {
    return Config.getHeightAbsolute(game, position.y, size.y);
  }

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
    final ySize = Config.groundHeight(game) / 6;
    size = Vector2(ySize, ySize * 4 / 5);

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
    isOnGround = false;
    velocity.y =
        -Config.gravity; // Устанавливаем отрицательную скорость для прыжка
    playAnimation();
  }

  void voice(double value, double threshold) {
    isOnGround = false;
    final valueRatio = (value - threshold) / (-1 - threshold);
    // velocity.y = -valueRatio * Config.gravity * 6;
    velocity.y = -valueRatio * Config.gravity * 2;
    playAnimation();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Применяем гравитацию
    velocity.y += Config.gravity * dt;
    position.y += velocity.y * dt;

    // Проверяем, не находится ли персонаж ниже уровня земли
    if (position.y >= game.size.y - (game.size.y / 5) - size.y / 2) {
      position.y = game.size.y - (game.size.y / 5) - size.y / 2;
      isOnGround = true;
      velocity.y = 0;
    }

    // Проверка на столкновение с потолком (не даем птице выйти за пределы)
    if (position.y <= Config.ceilingHeight + size.y / 2) {
      position.y = Config.ceilingHeight + size.y / 2;
      velocity.y = 0;
    }
  }

  @override
  void onCollision(intersectionPoints, other) {
    if (other is Thorn || other is Finish) {
      game.overlays.add('gameOver');
      game.pauseEngine();
    }

    // Проверка коллизии с потолком
    if (other is Ceiling) {
      // Ограничиваем высоту птицы, если она столкнулась с потолком
      position.y = Config.ceilingHeight + size.y / 2;
      velocity.y = 0;
    }

    super.onCollision(intersectionPoints, other);
  }

  void reset() {
    position = Vector2(128, 0 + 128);
    isOnGround = false;
    velocity = Vector2.zero();
  }
}
