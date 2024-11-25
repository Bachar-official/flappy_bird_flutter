import 'package:flame/components.dart';
import 'package:flappy_bird/game/config.dart';
import 'package:flappy_bird/game/game.dart';
import 'package:flutter/material.dart';

class CurrentScore extends TextComponent with HasGameRef<FlappyBirdGame> {
  int score;
  double? time;

  CurrentScore(this.score, {super.key, this.time});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    anchor = Anchor.topCenter;
    position = Vector2(gameRef.size.x / 2, -Config.ceilingHeight / 4);
    text = 'Количество списанных часов: ${(score / 60).toStringAsFixed(2)}';
    textRenderer = TextPaint(
      style: const TextStyle(
        fontFamily: 'Bip',
        fontSize: Config.ceilingHeight,
        color: Color.fromARGB(255, 8, 57, 97),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  String getText({double? newTime}) => text =
      'Количество списанных часов: ${(score / 60).toStringAsFixed(2)} ${newTime != null ? 'Время: ${newTime.toStringAsFixed(2)}' : ''}';

  void setScore(int newScore, {double? newTime}) {
    score = newScore;
    getText(newTime: newTime);
  }
}
