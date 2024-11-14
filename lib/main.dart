import 'package:flame/game.dart';
import 'package:flappy_bird/entity/score.dart';
import 'package:flappy_bird/game/game.dart';
import 'package:flappy_bird/screens/game_over_screen.dart';
import 'package:flappy_bird/screens/main_screen.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final game = FlappyBirdGame();
  List<Score> scoreBoard = [];
  runApp(
    MaterialApp(
      home: GameWidget(
        game: game,
        initialActiveOverlays: const [
          'mainMenu',
        ],
        overlayBuilderMap: {
          'mainMenu': (context, _) => MainScreen(game: game),
          'gameOver': (context, _) => GameOverScreen(game: game, scoreBoard: scoreBoard,),
        },
      ),
    ),
  );
}
