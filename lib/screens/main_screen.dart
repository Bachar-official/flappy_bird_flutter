import 'dart:math';
import 'dart:typed_data';

import 'package:flappy_bird/game/game.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';

class MainScreen extends StatefulWidget {
  final FlappyBirdGame game;
  const MainScreen({super.key, required this.game});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController nameC = TextEditingController(text: '');
  final record = AudioRecorder();
  late final Stream audioStream;

  @override
  void initState() {
    super.initState();
    widget.game.pauseEngine();
    nameC.addListener(() => setState(() {}));
    setStream();
  }

  void setStream() async {
    audioStream = await record
        .startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  label: Text('Имя игрока'),
                ),
                controller: nameC,
              ),
            ),
            ElevatedButton(
              onPressed: nameC.value.text.isEmpty
                  ? null
                  : () {
                      widget.game.overlays.remove('mainMenu');
                      widget.game.setPlayerName(nameC.value.text);
                      widget.game.setAudioStream(audioStream);
                      widget.game.resumeEngine();
                    },
              child: const Text('Начать игру'),
            ),
          ],
        ),
      ),
    );
  }
}
