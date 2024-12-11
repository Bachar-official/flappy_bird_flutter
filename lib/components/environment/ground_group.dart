import 'package:flame/components.dart';
import 'package:flappy_bird/components/environment/ground.dart';
import 'package:flappy_bird/game/game.dart';
import 'package:flappy_bird/game/config.dart';

class GroundGroup extends PositionComponent with HasGameRef<FlappyBirdGame> {
  late List<Ground> grounds;
  final Config config;

  GroundGroup({required this.config});

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Убедитесь, что земля будет полностью заполнять экран.
    grounds = [];
    int numGrounds =
        (gameRef.size.x / (608 - 300)).ceil(); // 50 — это ширина одной земли
    for (int i = 0; i < numGrounds; i++) {
      // Размещаем землю по оси X, чтобы она заполнила экран.
      var ground = Ground(config: config);
      ground.position = Vector2(i * 608, config.groundHeight(gameRef));
      grounds.add(ground);
      add(ground); // Добавляем компонент земли на экран
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Все компоненты земли двигаются влево
    for (var ground in grounds) {
      ground.position.x -= config.gameSpeed * dt;
    }

    // Когда все компоненты земли покидают экран, перемещаем их в конец.
    if (grounds.isNotEmpty && grounds.first.position.x < -608) {
      var firstGround = grounds.removeAt(0);
      firstGround.position =
          Vector2(grounds.last.position.x + 608, config.groundHeight(gameRef));
      grounds.add(firstGround);
    }
  }
}
