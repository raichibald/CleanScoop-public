import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc.dart';
import 'package:clean_scoop/design_system/src/assets/assets.gen.dart';
import 'package:clean_scoop/game/clean_scoop_game.dart';
import 'package:clean_scoop/game_overlay/game_overlay.dart';
import 'package:clean_scoop/score/score_repository.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();

  static Widget withBloc() => BlocProvider(
        create: (context) => CleanGrabBloc(
          scoreRepository: context.read<ScoreRepository>(),
        ),
        child: const App(),
      );
}

class _AppState extends State<App> with TickerProviderStateMixin {
  late final CleanGrabBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<CleanGrabBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            GameWidget(
              game: TapGame(bloc: _bloc),
              overlayBuilderMap: {
                'MainMenu': (context, game) => MainMenuOverlay(
                      game: game as TapGame,
                    ),
                'GameControls': (context, game) => GameControlsOverlay.withBloc(
                      game: game as TapGame,
                      bloc: _bloc,
                    ),
                'GamePaused': (context, game) => GamePausedOverlay.withBloc(
                      game: game as TapGame,
                      bloc: _bloc,
                    ),
                'GameOver': (context, game) => GameOverOverlay.withBloc(
                      game: game as TapGame,
                      bloc: _bloc,
                    ),
              },
              backgroundBuilder: (context) => Stack(
                children: [
                  Container(color: const Color(0xFF0BB458)),
                  Positioned.fill(
                    child: Image.asset(
                      Assets.images.imgBackgroundBars.path,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
