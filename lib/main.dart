import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'space_invader_game.dart';
import 'package:my_game/logic/game_bloc.dart';

void main() {
  runApp(const SpaceInvadersApp());
}

class SpaceInvadersApp extends StatelessWidget {
  const SpaceInvadersApp({super.key});

  @override
  Widget build(BuildContext context) {
    final game = SpaceInvadersGame();

    return BlocProvider(
      create: (_) => GameBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Space Invaders',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
        ),
        home: Scaffold(
          body: GameWidget<SpaceInvadersGame>(
            game: game,
            overlayBuilderMap: {
              'WinOverlay': (context, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "🎉 You Won!",
                      style: TextStyle(fontSize: 32, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        game.resetGame();
                      },
                      child: const Text("Restart"),
                    ),
                  ],
                ),
              ),
              'LoseOverlay': (context, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "💀 You Lost!",
                      style: TextStyle(fontSize: 32, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        game.resetGame();
                      },
                      child: const Text("Try Again"),
                    ),
                  ],
                ),
              ),
            },
          ),
        ),
      ),
    );
  }
}
