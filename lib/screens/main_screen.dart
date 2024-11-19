import 'dart:async';

import 'package:flappy_bird/components/levels/level.dart';
import 'package:flappy_bird/components/song_button.dart';
import 'package:flappy_bird/game/game.dart';
import 'package:flappy_bird/utils/calculate_volume.dart';
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
  StreamController<bool> controller = StreamController.broadcast();
  final record = AudioRecorder();
  // late final Stream audioStream;
  bool triggered = false;

  @override
  void initState() {
    super.initState();
    widget.game.pauseEngine();
    readLevel();
    nameC.addListener(() => setState(() {}));
    setStream();
    readData();
  }

  void setStream() async {
    // audioStream = await record.startStream(const RecordConfig(
    //     encoder: AudioEncoder.pcm16bits, noiseSuppress: true));
    // await for (var a in audioStream) {
    //   var value = 1000 / calculateVolume(a) * triggerCoefficient;
    //   controller.add(value > 10);
    // }
  }

  void readLevel() async {
    try {
      var lvl = await loadLevel('level1.json');
      widget.game.setLevel(lvl);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  void readData() async {
    await for (var a in controller.stream) {
      // print(a);
    }
  }

  List<Widget> songs = [
    SongButton(
      group: 'На-на',
      song: 'Фаина',
      onTap: () {},
    ),
    SongButton(
      group: 'Технология',
      song: 'Нажми на кнопку',
      onTap: () {},
    ),
    SongButton(
      group: 'Кай Метов',
      song: 'Position №1',
      onTap: () {},
    ),
    SongButton(
      group: 'Филипп Киркоров',
      song: 'Зайка моя',
      onTap: () {},
    ),
    SongButton(
      group: 'Надежда Кадышева',
      song: 'А я вовсе не колдунья',
      onTap: () {},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Имя игрока'),
                ),
                controller: nameC,
              ),
              ElevatedButton(
                onPressed: nameC.value.text.isEmpty
                    ? null
                    : () {
                        widget.game.overlays.remove('mainMenu');
                        widget.game.setPlayerName(nameC.value.text);
                        // widget.game.setAudioStream(audioStream);
                        widget.game.resumeEngine();
                      },
                child: const Text('Начать игру'),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2 / 1,
                  ),
                  itemCount: songs.length,
                  itemBuilder: (context, index) => songs[index],
                ),
              ),
              Slider(
                min: 0.5,
                max: 2.0,
                value: triggerCoefficient,
                onChanged: (value) =>
                    setState(() => triggerCoefficient = value),
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
                        color: snapshot.data ?? false ? Colors.green : Colors.red,
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
