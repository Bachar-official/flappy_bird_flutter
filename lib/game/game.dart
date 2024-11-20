import 'dart:io';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy_bird/components/bonuses/finish.dart';
import 'package:flappy_bird/components/bonuses/hour.dart';
import 'package:flappy_bird/components/enemies/thorn.dart';
import 'package:flappy_bird/components/enemies/thorn_position.dart';
import 'package:flappy_bird/components/environment/background.dart';
import 'package:flappy_bird/components/bird.dart';
import 'package:flappy_bird/components/environment/ceiling_group.dart';
import 'package:flappy_bird/components/cloud_group.dart';
import 'package:flappy_bird/components/environment/ground_group.dart';
import 'package:flappy_bird/components/environment/lyrics.dart';
import 'package:flappy_bird/components/levels/level.dart';
import 'package:flappy_bird/components/levels/words.dart';
import 'package:flappy_bird/game/config.dart';
import 'package:flutter/material.dart';

class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection {
  late Bird _bird;
  Stream<double>? stream;
  double threshold = -20.0;

  Timer interval = Timer(Config.pipeInterval, repeat: true);
  Timer groundInterval = Timer(0.25, repeat: true);
  Timer cloudInterval = Timer(2, repeat: true);
  Timer scoreTimer = Timer(1, repeat: true);
  int score = 0;
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
      final file = File(level!.music);
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
      GroundGroup(),
      CeilingGroup(),
      Background(),
      Lyrics(
          words: level?.words ?? [],
          startPosition: Vector2(size.x / 2, size.y - Config.groundHeight / 2),
          verticalSpacing: 10.0),
      _bird,
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
              thornPosition:
                  thorn.bottom ? ThornPosition.bottom : ThornPosition.top,
              height: thorn.height *
                  (size.y - Config.ceilingHeight - Config.groundHeight) /
                  100,
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
              score: hour.score,
              yPos: (size.y - Config.ceilingHeight - Config.groundHeight) -
                  (size.y - Config.ceilingHeight - Config.groundHeight) /
                      100 *
                      hour.pos,
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
  }

  void reset() {
    _bird.reset();
    score = 0;
    playerName = '';
    removeAll(children);
    _bird.parent == null;
    remove(_bird);
  }
}
