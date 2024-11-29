import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
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

class FlappyBirdGame extends FlameGame
    with TapDetector, HasCollisionDetection, KeyboardEvents {
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
  double time = 0;
  final File markersFile = File('markers.txt');
  final player = AudioPlayer();

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
      await player.play(BytesSource(bytes));
    }
  }

  Future<void> stopBackgroundMusic() async {
    await player.stop();
  }

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'bird.png',
      'ground.png',
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
    if (!await markersFile.exists()) {
      await markersFile.create(recursive: true);
    }
  }

  void initializeGame() {
    if (isFirstTime) {
      _bird = Bird(
        position: Vector2(128, 128),
      );
    }

    markersFile.writeAsStringSync('');

    addAll([
      WinterBackground(),
      GroundGroup(),
      CeilingGroup(),
      KaraokeComponent(
          wordsList: level?.words ?? [],
          position: Vector2(size.x / 2, size.y - (size.y / 5) / 2)),
      _bird,
      _currentScore,
      Finish(),
    ]);

    cloudInterval.onTick = () => add(
          CloudGroup(),
        );

    for (var thorn in level?.thorns ?? []) {
      add(
        Thorn(
          thorn: thorn,
        ),
      );
    }

    for (var hour in level?.hours ?? []) {
      add(
        Hour(
          data: hour,
        ),
      );
    }

    if (stream != null) {
      stream!.listen((event) {
        if (event > threshold) {
          _bird.voice(event, threshold);
        }
      });
    }

    isFirstTime = false;
  }

  @override
  void onTap() {
    markersFile.writeAsStringSync(
        'time: ${time.toStringAsFixed(2)}, birdPosition: ${_bird.currentHeight.toStringAsFixed(2)}\n',
        mode: FileMode.append);
  }

  @override
  void update(double dt) {
    super.update(dt);
    time += dt;
    interval.update(dt);
    groundInterval.update(dt);
    cloudInterval.update(dt);
    scoreTimer.update(dt);
    _currentScore.setScore(score, newTime: time);
  }

  void reset() {
    _bird.reset();
    score = 0;
    time = 0;
    playerName = '';
    removeAll(children);
    _bird.parent == null;
    _currentScore.parent == null;
    remove(_bird);
  }
}
