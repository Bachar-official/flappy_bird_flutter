import 'package:flame/components.dart';
import 'package:flappy_bird/components/environment/ceiling.dart';
import 'package:flappy_bird/game/config.dart';
import 'package:flappy_bird/game/game.dart';

class CeilingGroup extends PositionComponent with HasGameRef<FlappyBirdGame> {
  late List<Ceiling> ceilings = [];
  final Config config;

  CeilingGroup({required this.config});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    ceilings = [];
    int numCeilings = (gameRef.size.x / (50)).ceil();
    for (int i = 0; i < numCeilings; i++) {
      var ceiling = Ceiling(config: config);
      ceiling.position = Vector2(i * 50, 0);
      ceilings.add(ceiling);
      add(ceiling);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    for (var ceiling in ceilings) {
      ceiling.position.x -= config.gameSpeed * dt;
    }

    if (ceilings.isNotEmpty && ceilings.first.position.x < -50) {
      var firstCeiling = ceilings.removeAt(0);
      firstCeiling.position = Vector2(
        ceilings.last.position.x + 50,
        0,
      );
      ceilings.add(firstCeiling);
    }
  }
}
