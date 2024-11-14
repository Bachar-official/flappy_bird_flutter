import 'package:flappy_bird/entity/score.dart';
import 'package:flutter/material.dart';

class Scoreboard extends StatelessWidget {
  final List<Score> scoreBoard;
  const Scoreboard({super.key, required this.scoreBoard});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: scoreBoard.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: ListTile(
            leading: Text((index + 1).toString()),
            title: Text(scoreBoard[index].name),
            subtitle: Text(scoreBoard[index].score.toString()),
          ),
        );
      },
      separatorBuilder: (context, _) => const Divider(),
    );
  }
}