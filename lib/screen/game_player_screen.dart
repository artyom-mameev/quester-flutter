import 'package:flutter/material.dart';
import 'package:quester_flutter/domain/text_game.dart';

import '../logic/game_player.dart';

class GamePlayerScreen extends StatefulWidget {
  final GameNode gameNode;

  const GamePlayerScreen({super.key, required this.gameNode});

  @override
  State<GamePlayerScreen> createState() => _GamePlayerScreenState();
}

class _GamePlayerScreenState extends State<GamePlayerScreen> {
  final GamePlayer gamePlayer = GamePlayer();
  late RoomNode currentRoomNode;

  @override
  void initState() {
    super.initState();

    currentRoomNode = widget.gameNode as RoomNode;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> choiceButtons = [];

    for (final nextChoice in gamePlayer.getNextChoices(currentRoomNode)) {
      choiceButtons.add(
        Padding(
          padding: const EdgeInsets.all(3),
          child: ElevatedButton(
            onPressed: () {
              if (nextChoice.isFlag) {
                gamePlayer.activateFlag(nextChoice.id);
              }
              setState(() {
                currentRoomNode = nextChoice.nextRoomNode as RoomNode;
              });
            },
            // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
            style: ElevatedButton.styleFrom(
                elevation: 12.0,
                textStyle: const TextStyle(fontStyle: FontStyle.normal)),
            child: Text(nextChoice.text,
                style: const TextStyle(color: Colors.white)),
          ),
        ),
      );
    }

    if (choiceButtons.isEmpty) {
      choiceButtons.add(
        ElevatedButton(
          onPressed: () {
            setState(() {
              gamePlayer.clearFlags();
              currentRoomNode = widget.gameNode as RoomNode;
            });
          },
          // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
          style: ElevatedButton.styleFrom(
              elevation: 12.0,
              textStyle: const TextStyle(fontStyle: FontStyle.normal)),
          child:
              const Text("Start Again", style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(currentRoomNode.name),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(currentRoomNode.description),
              const SizedBox(height: 10),
              for (final choice in choiceButtons) choice,
            ],
          ),
        ),
      ),
    );
  }
}
