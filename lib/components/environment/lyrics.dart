import 'package:flame/components.dart';
import 'package:flappy_bird/components/levels/words.dart';
import 'package:flappy_bird/game/config.dart';
import 'package:flappy_bird/game/game.dart';
import 'package:flutter/material.dart';

class Lyrics extends Component with HasGameRef<FlappyBirdGame> {
  final List<Words> words; // Массив слов с временем появления/исчезновения
  final double verticalSpacing; // Расстояние между строками
  final Vector2 startPosition; // Начальная позиция первой строки

  double elapsedTime = 0; // Текущее время
  int currentWordIndex = 0; // Индекс текущего слова

  final List<TextComponent> textLines = []; // Текущие строки на экране

  Lyrics({
    required this.words,
    required this.startPosition,
    this.verticalSpacing = 10.0,
  });

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

    // Проверяем, нужно ли обновить строки
    while (currentWordIndex < words.length &&
        elapsedTime >= words[currentWordIndex].start) {
      // Выбираем строку для отображения текста
      final lineIndex = currentWordIndex % 2;

      // Обновляем текст строки
      textLines[lineIndex].text = words[currentWordIndex].text;

      // Очистка другой строки
      final otherLineIndex = (lineIndex + 1) % 2;
      if (currentWordIndex > 0 &&
          elapsedTime >= words[currentWordIndex - 1].end) {
        textLines[otherLineIndex].text = '';
      }

      // Переходим к следующему слову
      currentWordIndex++;
    }

    // Убираем текст, если его время истекло
    for (int i = 0; i < textLines.length; i++) {
      if (currentWordIndex > i &&
          elapsedTime >= words[currentWordIndex - (i + 1)].end) {
        textLines[i].text = '';
      }
    }
  }
}
