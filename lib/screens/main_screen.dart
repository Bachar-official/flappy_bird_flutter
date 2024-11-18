import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flappy_bird/game/game.dart';
import 'package:flappy_bird/utils/calculate_volume.dart';
import 'package:flappy_bird/utils/pipe_data.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';

class MainScreen extends StatefulWidget {
  final FlappyBirdGame game;
  const MainScreen({super.key, required this.game});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double triggerCoefficient = 1;
  final TextEditingController nameC = TextEditingController(text: '');
  StreamController controller = StreamController.broadcast();
  final record = AudioRecorder();
  late final Stream audioStream;
  bool triggered = false;
  List<PipeData> pipes = [];

  void init() async {
    try {
      pipes = await loadPipes('pipes.json');
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void initState() {
    super.initState();
    widget.game.pauseEngine();
    nameC.addListener(() => setState(() {}));
    setStream();
    readData();
    init();
  }

  void setStream() async {
    audioStream = await record.startStream(const RecordConfig(
        encoder: AudioEncoder.pcm16bits, noiseSuppress: true));
    await for (var a in audioStream) {
      var value = 1000 / calculateVolume(a) * triggerCoefficient;
      controller.add(value > 10);
    }
  }

  void readData() async {
    await for (var a in controller.stream) {
      // print(a);
    }
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
                      widget.game.setPipes(pipes);
                    },
              child: const Text('Начать игру'),
            ),
            Slider(
              min: 0.5,
              max: 2.0,
              value: triggerCoefficient,
              onChanged: (value) => setState(() => triggerCoefficient = value),
            ),
            const Text('Порог срабатывания'),
            StreamBuilder(
                stream: controller.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      width: 100,
                      height: 100,
                      child: ColoredBox(
                        color: snapshot.data ? Colors.green : Colors.red,
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
