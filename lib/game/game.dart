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
  late Config config;
  Stream<double>? stream;
  double threshold = -20.0;
  double volume = .5;

  Timer groundInterval = Timer(0.25, repeat: true);
  Timer cloudInterval = Timer(2, repeat: true);
  Timer scoreTimer = Timer(1, repeat: true);
  int score = 0;
  late CurrentScore currentScore;
  String playerName = '';
  Level? level;
  bool isFirstTime = true;
  double time = 0;
  final File markersFile = File('markers.txt');
  final player = AudioPlayer();

  void setPlayerName(String name) => playerName = name;
  void setThreshold(double value) => threshold = value;
  void setVolume(double value) => volume = value;
  void setAudioStream(Stream<double> stream) => this.stream = stream;
  void setConfig(Config config) => this.config = config;
  void setLevel(Level level) {
    this.level = level;
    initializeGame();
  }

  Future<void> playBackgroundMusic() async {
    if (level != null) {
      final file = File('levels/${level!.music}');
      final bytes = await file.readAsBytes();
      await player.setVolume(volume);
      await Future.delayed(Duration(milliseconds: config.startDelay), () async {
        await player.play(BytesSource(bytes));
      });
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
    config = await Config.getConfigFromFile();
    currentScore = CurrentScore(0, config: config);
  }

  void initializeGame() {
    if (isFirstTime) {
      _bird = Bird(
        config: config,
        position: Vector2(128, 128),
      );
      currentScore = CurrentScore(0, config: config);
    }

    markersFile.writeAsStringSync('');

    addAll([
      WinterBackground(),
      GroundGroup(config: config),
      CeilingGroup(config: config),
      KaraokeComponent(
          wordsList: level?.words ?? [],
          position: Vector2(size.x / 2, size.y - (size.y / 5) / 2)),
      _bird,
      currentScore,
      Finish(config: config),
    ]);

    for (var thorn in level?.thorns ?? []) {
      add(
        Thorn(thorn: thorn, config: config),
      );
    }

    for (var hour in level?.hours ?? []) {
      add(
        Hour(data: hour, config: config),
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
    groundInterval.update(dt);
    cloudInterval.update(dt);
    scoreTimer.update(dt);
    currentScore.setScore(score, newTime: time);
  }

  void reset() {
    _bird.reset();
    score = 0;
    time = 0;
    playerName = '';
    removeAll(children);
    _bird.parent == null;
    currentScore.parent == null;
    remove(_bird);
    remove(currentScore);
  }
}
