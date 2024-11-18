import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flappy_bird/components/background.dart';
import 'package:flappy_bird/components/bird.dart';
import 'package:flappy_bird/components/cloud_group.dart';
import 'package:flappy_bird/components/ground_group.dart';
import 'package:flappy_bird/components/pipe.dart';
import 'package:flappy_bird/components/pipe_group.dart';
import 'package:flappy_bird/game/config.dart';
import 'package:flappy_bird/utils/calculate_volume.dart';
import 'package:flappy_bird/utils/pipe_data.dart';

class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection {
  late Bird _bird;

  Timer interval = Timer(Config.pipeInterval, repeat: true);
  Timer groundInterval = Timer(0.25, repeat: true);
  Timer cloudInterval = Timer(2, repeat: true);
  Timer scoreTimer = Timer(1, repeat: true);
  int score = 0;
  String playerName = '';
  List<PipeData> pipes = [];

  void setPlayerName(String name) => playerName = name;
  void setAudioStream(Stream<dynamic> stream) async {
    // await for (var event in stream) {
    //   if (calculateVolume(event) < 140) {
    //     _bird.jump();
    //   }
    // }
  }
  void setPipes(List<PipeData> pipes) => this.pipes = pipes;

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'bird.png',
      'pipe.png',
      'pipe-rotated.png',
      'ground.png',
      'background.png',
      'cloud.png',
    ]);
    camera.viewfinder.anchor = Anchor.topLeft;

    initializeGame(true);
  }

  void initializeGame(bool isFirstTime) {
    if (!isFirstTime) {
      removeAll(children);
    }
    _bird = Bird(
      position: Vector2(128, 128),
    );

    addAll([
      Background(),
      _bird,
    ]);

    // interval.onTick = () => add(PipeGroup());
    groundInterval.onTick = () => add(GroundGroup());
    cloudInterval.onTick = () => add(CloudGroup());
    scoreTimer.onTick = () => score++;
    print(pipes);
    for (var pipe in pipes) {
      Future.delayed(Duration(milliseconds: (pipe.time / 1000).toInt()), () {
        add(Pipe(
          pipePosition: pipe.bottom ? PipePosition.bottom : PipePosition.top,
          height: pipe.height,
        ));
      });
    }
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
    cloudInterval.update(dt);
    scoreTimer.update(dt);
  }

  void reset() {
    _bird.reset();
    score = 0;
    playerName = '';
    initializeGame(false);
  }
}
