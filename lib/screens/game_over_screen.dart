import 'package:flappy_bird/entity/score.dart';
import 'package:flappy_bird/game/game.dart';
import 'package:flappy_bird/widgets/scoreboard.dart';
import 'package:flutter/material.dart';

class GameOverScreen extends StatefulWidget {
  final FlappyBirdGame game;
  final List<Score> scoreBoard;
  const GameOverScreen(
      {super.key, required this.game, required this.scoreBoard});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  @override
  void initState() {
    super.initState();
    widget.scoreBoard.add(Score(widget.game.playerName, widget.game.score));
    widget.scoreBoard.sort((Score a, Score b) => b.score.compareTo(a.score));
    widget.game.reset();
    widget.game.stopBackgroundMusic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Игра окончена!'),
        actions: [
          ElevatedButton(
            onPressed: () {
              widget.game.overlays.remove('gameOver');
              widget.game.overlays.add('mainMenu');
            },
            child: const Text('Заново'),
          ),
        ],
      ),
      body: Scoreboard(
        scoreBoard: widget.scoreBoard,
      ),
    );
  }
}
