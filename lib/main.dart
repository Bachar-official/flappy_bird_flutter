import 'package:flame/game.dart';
import 'package:flappy_bird/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const GameWidget<FlappyBirdGame>.controlled(
      gameFactory: FlappyBirdGame.new,
    ),
  );
}
