import 'package:flame/components.dart';
import 'package:flappy_bird/components/levels/words.dart';
import 'package:flappy_bird/game/config.dart';
import 'package:flappy_bird/game/game.dart';
import 'package:flutter/material.dart';

class Lyrics extends Component with HasGameRef<FlappyBirdGame> {
  final List<Words> words; // Массив слов с временем появления/исчезновения
  final double verticalSpacing; // Расстояние между строками
  final Vector2 startPosition; // Начальная позиция первой строки

  // Текущие строки на экране

  Lyrics({
    required this.words,
    required this.startPosition,
    this.verticalSpacing = 10.0,
  });

  double elapsedTime = 0; // Текущее время
  int currentWordIndex = 0; // Индекс текущего слова

  final List<TextComponent> textLines = [];

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Инициализация двух строк текста
    for (int i = 0; i < 2; i++) {
      final textComponent = TextComponent(
        text: '',
        position: Vector2(
          startPosition.x,
          startPosition.y + i * verticalSpacing,
        ),
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize:
                (game.size.y - Config.groundHeight - Config.ceilingHeight) / 10,
            color: const Color(0xFFFFFFFF),
          ),
        ),
        anchor: Anchor.center,
      );
      textLines.add(textComponent);
      add(textComponent);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Обновляем текущее время
    elapsedTime += dt;
  }
}
