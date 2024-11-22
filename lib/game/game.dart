import 'dart:io';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy_bird/components/bonuses/finish.dart';
import 'package:flappy_bird/components/bonuses/hour.dart';
import 'package:flappy_bird/components/enemies/thorn.dart';
import 'package:flappy_bird/components/bird.dart';
import 'package:flappy_bird/components/environment/ceiling_group.dart';
import 'package:flappy_bird/components/cloud_group.dart';
import 'package:flappy_bird/components/environment/current_score.dart';
import 'package:flappy_bird/components/environment/ground_group.dart';
import 'package:flappy_bird/components/environment/karaoke_component.dart';
import 'package:flappy_bird/components/environment/winter_background.dart';
import 'package:flappy_bird/components/levels/level.dart';
import 'package:flappy_bird/game/config.dart';

class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection {
  late Bird _bird;
  Stream<double>? stream;
  double threshold = -20.0;

  Timer interval = Timer(Config.pipeInterval, repeat: true);
  Timer groundInterval = Timer(0.25, repeat: true);
  Timer cloudInterval = Timer(2, repeat: true);
  Timer scoreTimer = Timer(1, repeat: true);
  int score = 0;
  final CurrentScore _currentScore = CurrentScore(0);
  String playerName = '';
  Level? level;
  bool isFirstTime = true;

  void setPlayerName(String name) => playerName = name;
  void setThreshold(double value) => threshold = value;
  void setAudioStream(Stream<double> stream) => this.stream = stream;
  void setLevel(Level level) {
    this.level = level;
    initializeGame();
  }

  Future<void> playBackgroundMusic() async {
    if (level != null) {
      final file = File('levels/${level!.music}');
      final bytes = await file.readAsBytes();
      await FlameAudio.bgm.audioPlayer.play(BytesSource(bytes), volume: 0.2);
    }
  }

  Future<void> stopBackgroundMusic() async {
    await FlameAudio.bgm.audioPlayer.stop();
  }

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'bird.png',
      'ground.png',
      'background.png',
      'cloud.png',
      'ceiling.png',
      'thorn.png',
      'thorn-rotated.png',
      'hours-15.png',
      'hours-30.png',
      'hours-45.png',
      'hours-60.png',
      'finish.png',
      'winter_background.png',
      'block.png',
    ]);

    camera.viewfinder.anchor = Anchor.topLeft;
    FlameAudio.bgm.initialize();
  }

  void initializeGame() {
    if (isFirstTime) {
      _bird = Bird(
        position: Vector2(128, 128),
      );
    }

    addAll([
      WinterBackground(),
      GroundGroup(),
      CeilingGroup(),
      KaraokeComponent(
          wordsList: level?.words ?? [],
          position: Vector2(size.x / 2, size.y - (size.y / 5) / 2)),
      _bird,
      _currentScore,
    ]);

    cloudInterval.onTick = () => add(
          CloudGroup(),
        );

    for (var thorn in level?.thorns ?? []) {
      final thornTimer = TimerComponent(
        period: thorn.time,
        removeOnFinish: true,
        repeat: false,
        onTick: () {
          add(
            Thorn(
              thorn: thorn,
            ),
          );
        },
      );
      add(thornTimer);
    }

    for (var hour in level?.hours ?? []) {
      final hourTimer = TimerComponent(
        period: hour.time,
        repeat: false,
        removeOnFinish: true,
        onTick: () {
          add(
            Hour(
              data: hour,
            ),
          );
        },
      );
      add(hourTimer);
    }

    final finishTimer = TimerComponent(
      period: level?.finishAt ?? 0,
      repeat: false,
      removeOnFinish: true,
      onTick: () {
        add(
          Finish(),
        );
      },
    );
    add(
      finishTimer,
    );

    if (stream != null) {
      stream!.listen((event) {
        _bird.voice(event, threshold);
      });
    }

    isFirstTime = false;
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
    _currentScore.setScore(score);
  }

  void reset() {
    _bird.reset();
    score = 0;
    playerName = '';
    removeAll(children);
    _bird.parent == null;
    _currentScore.parent == null;
    remove(_bird);
  }
}
