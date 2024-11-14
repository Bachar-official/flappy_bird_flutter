import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flappy_bird/components/bird.dart';
import 'package:flappy_bird/components/ground_group.dart';
import 'package:flappy_bird/components/pipe_group.dart';
import 'package:flappy_bird/game/config.dart';

class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection {
  late Bird _bird;
  Timer interval = Timer(Config.pipeInterval, repeat: true);
  Timer groundInterval = Timer(0.25, repeat: true);

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'bird.png',
      'pipe.png',
      'pipe-rotated.png',
      'ground.png',
    ]);
    camera.viewfinder.anchor = Anchor.topLeft;

    _bird = Bird(
      position: Vector2(128, 0 + 128),
    );

    world.addAll([
      _bird,
    ]);

    interval.onTick = () => add(PipeGroup());
    groundInterval.onTick = () => add(GroundGroup());
  }

  @override
  void onTap() {
    _bird.jump();
  }

  @override
  void update(double dt) {
    super.update(dt);
    interval.update(dt);
    groundInterval.update(dt);
  }
}
