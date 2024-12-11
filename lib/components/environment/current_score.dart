import 'package:flame/components.dart';
import 'package:flappy_bird/game/config.dart';
import 'package:flappy_bird/game/game.dart';
import 'package:flutter/material.dart';

class CurrentScore extends TextComponent with HasGameRef<FlappyBirdGame> {
  int score;
  double? time;
  final Config config;

  CurrentScore(this.score, {super.key, this.time, required this.config});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    anchor = Anchor.topCenter;
    position = Vector2(gameRef.size.x / 2, -config.ceilingHeight / 4);
    text = 'Количество списанных часов: ${(score / 60).toStringAsFixed(2)}';
    textRenderer = TextPaint(
      style: TextStyle(
        fontFamily: 'Bip',
        fontSize: config.ceilingHeight,
        color: const Color.fromARGB(255, 8, 57, 97),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void scored() {
    textRenderer = TextPaint(
      style: TextStyle(
        fontFamily: 'Bip',
        fontSize: config.ceilingHeight,
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      textRenderer = TextPaint(
        style: TextStyle(
          fontFamily: 'Bip',
          fontSize: config.ceilingHeight,
          color: const Color.fromARGB(255, 8, 57, 97),
          fontWeight: FontWeight.bold,
        ),
      );
    });
  }

  void damaged() {
    textRenderer = TextPaint(
      style: TextStyle(
        fontFamily: 'Bip',
        fontSize: config.ceilingHeight,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      textRenderer = TextPaint(
        style: TextStyle(
          fontFamily: 'Bip',
          fontSize: config.ceilingHeight,
          color: const Color.fromARGB(255, 8, 57, 97),
          fontWeight: FontWeight.bold,
        ),
      );
    });
  }

  String getText({double? newTime}) => text =
      'Количество списанных часов: ${(score / 60).toStringAsFixed(2)} ${newTime != null ? 'Время: ${newTime.toStringAsFixed(2)}' : ''}';

  void setScore(int newScore, {double? newTime}) {
    score = newScore;
    getText(newTime: newTime);
  }
}
