import 'dart:async';

import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc.dart';
import 'package:clean_scoop/design_system/src/assets/assets.gen.dart';
import 'package:clean_scoop/game/clean_scoop_game.dart';
import 'package:clean_scoop/game/widget/game_controls_overlay.dart';
import 'package:clean_scoop/game/widget/game_over_overlay.dart';
import 'package:clean_scoop/game/widget/game_paused_overlay.dart';
import 'package:clean_scoop/game/widget/main_menu_overlay.dart';
import 'package:clean_scoop/key_value_storage/key_value_storage.dart';
import 'package:clean_scoop/score/app_score_repository.dart';
import 'package:clean_scoop/score/score_repository.dart';
import 'package:clean_scoop/shared_preferences_key_value_storage/shared_preferences_key_value_storage.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    final sharedPreferences = await SharedPreferences.getInstance();
    final storage = SharedPreferencesKeyValueStorage(
      sharedPreferences,
    );

    runApp(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<KeyValueStorage>(
            create: (context) => storage,
          ),
          RepositoryProvider<ScoreRepository>(
            create: (context) => AppScoreRepository(
              storage: storage,
            ),
          ),
        ],
        child: MyApp.withBloc(),
      ),
    );
  }, (error, stack) {
    // TODO: Handle app crash
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static Widget withBloc() => BlocProvider(
        create: (context) => CleanGrabBloc(
          scoreRepository: context.read<ScoreRepository>(),
        ),
        child: const MyApp(),
      );
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
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
              backgroundBuilder: (context) {
                return Stack(
                  children: [
                    Container(
                      color: const Color(0xFF0BB458),
                    ),
                    Positioned.fill(
                      child: Image.asset(
                        Assets.images.imgBackgroundBars.path,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
