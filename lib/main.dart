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
  double threshold = -20.0;
  double volume = .5;

  void setThreshold(double value) => threshold = value;
  void setVolume(double value) => volume = value;

  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'Bip',
      ),
      home: GameWidget(
        game: game,
        initialActiveOverlays: const [
          'mainMenu',
        ],
        overlayBuilderMap: {
          'mainMenu': (context, _) => MainScreen(
                game: game,
                threshold: threshold,
                volume: volume,
                setThreshold: setThreshold,
                setVolume: setVolume,
              ),
          'gameOver': (context, _) => GameOverScreen(
                game: game,
                scoreBoard: scoreBoard,
              ),
        },
      ),
    ),
  );
}
