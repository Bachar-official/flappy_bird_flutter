import 'package:flame/components.dart';
import 'package:flappy_bird/components/levels/words.dart';
import 'package:flappy_bird/game/game.dart';
import 'package:flutter/material.dart';

class KaraokeComponent extends Component with HasGameRef<FlappyBirdGame> {
  final List<Words> wordsList;
  final Vector2 position;
  late TextComponent line0;
  late TextComponent line1;

  KaraokeComponent({required this.wordsList, required this.position});

  double currentTime = 0.0;
  double spacing = 50.0;

  final highlightShadowColor = const Color(0xFF333333);
  final shadowColor = const Color(0xFFDDDDDD);

  var defaultRenderer = TextPaint(
    style: const TextStyle(
      fontSize: 40,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  );
  var highlihtRenderer = TextPaint(
    style: const TextStyle(
      color: Color.fromARGB(255, 90, 56, 5),
      fontSize: 40,
      fontWeight: FontWeight.bold,
    ),
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    defaultRenderer = TextPaint(
      style: TextStyle(
          fontSize: gameRef.size.y / 100 * 5,
          color: const Color(0xFF808080),
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              // bottomLeft
              offset: const Offset(-0.5, -0.5),
              color: shadowColor,
            ),
            Shadow(
              // bottomRight
              offset: const Offset(0.5, -0.5),
              color: shadowColor,
            ),
            Shadow(
              // topRight
              offset: const Offset(0.5, 0.5),
              color: shadowColor,
            ),
            Shadow(
              // topLeft
              offset: const Offset(-0.5, 0.5),
              color: shadowColor,
            ),
          ]),
    );
    highlihtRenderer = TextPaint(
      style: TextStyle(
          color: const Color.fromARGB(255, 255, 165, 30),
          fontSize: gameRef.size.y / 100 * 5,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              // bottomLeft
              offset: const Offset(-0.5, -0.5),
              color: highlightShadowColor,
            ),
            Shadow(
              // bottomRight
              offset: const Offset(0.5, -0.5),
              color: highlightShadowColor,
            ),
            Shadow(
              // topRight
              offset: const Offset(0.5, 0.5),
              color: highlightShadowColor,
            ),
            Shadow(
              // topLeft
              offset: const Offset(-0.5, 0.5),
              color: highlightShadowColor,
            ),
          ]),
    );
    line0 = TextComponent(text: '', textRenderer: defaultRenderer)
      ..position = position
      ..anchor = Anchor.center; // Позиция строки 0
    line1 = TextComponent(text: '', textRenderer: defaultRenderer)
      ..position = Vector2(position.x, position.y + spacing)
      ..anchor = Anchor.center; // Позиция строки 1
    add(line0);
    add(line1);
  }

  @override
  void update(double dt) {
    super.update(dt);
    currentTime += dt;

    // Обновляем строки в зависимости от времени
    for (var word in wordsList) {
      // Если текущий момент находится в диапазоне показа слова
      if (currentTime >= word.show && currentTime < word.start) {
        if (word.str == 0) {
          line0
            ..text = word.text
            ..textRenderer = defaultRenderer;
        } else {
          line1
            ..text = word.text
            ..textRenderer = defaultRenderer;
        }
      }

      // Если текущий момент находится в диапазоне закрашивания
      if (currentTime >= word.start && currentTime < word.end) {
        if (word.str == 0) {
          line0
            ..text = word.text
            ..textRenderer = highlihtRenderer;
        } else {
          line1
            ..text = word.text
            ..textRenderer = highlihtRenderer;
        }
      }

      // Если время слова закончилось, очищаем текст
      if (currentTime >= word.end) {
        if (word.str == 0) {
          line0.text = '';
        } else {
          line1.text = '';
        }
      }
    }
  }
}
