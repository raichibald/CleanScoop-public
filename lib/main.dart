import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc.dart';
import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc_event.dart';
import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc_state.dart';
import 'package:clean_scoop/design_system/src/assets/assets.gen.dart';
import 'package:clean_scoop/design_system/src/assets/fonts.gen.dart';
import 'package:clean_scoop/game/clean_scoop_game.dart';
import 'package:clean_scoop/game/models/game_state.dart';
import 'package:clean_scoop/game/widget/main_menu_overlay.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'game/widget/game_controls_overlay.dart';

void main() {
  runApp(MyApp.withBloc());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static Widget withBloc() => BlocProvider(
        create: (context) => CleanGrabBloc(),
        child: const MyApp(),
      );
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  late final CleanGrabBloc _bloc;

  late final AnimationController _gamePausedOverlayController = AnimationController(
    duration: const Duration(milliseconds: 800),
    vsync: this,
  );

  late final Animation<double> _gamePausedAnimation = CurvedAnimation(
    parent: _gamePausedOverlayController,
    curve: Curves.bounceOut,
  );

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
            // if (unwrappedGame != null)
            GameWidget(
              game: TapGame(bloc: _bloc),
              overlayBuilderMap: {
                'MainMenu': (context, game) => Padding(
                      padding: const EdgeInsets.only(top: 100, bottom: 64),
                      child: MainMenuOverlay(game: game as TapGame),
                    ),
                'GameOverlay': (context, game) => GameControlsOverlay.withBloc(
                      game: game as TapGame,
                      bloc: _bloc,
                    ),
                'GamePaused': (context, game) {
                  return BlocBuilder<CleanGrabBloc, CleanGrabBlocState>(
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 100),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ScaleTransition(
                                  scale: _gamePausedAnimation,
                                  child: SvgPicture.asset(
                                      Assets.icons.icoGamePausedLogo),
                                )
                              ],
                            ),
                            const Spacer(),
                            const Spacer(),
                            ScaleTransition(
                              scale: _gamePausedAnimation,
                              child: GestureDetector(
                                onTap: () async {
                                  final gg = game as TapGame;

                                  _bloc.add(
                                      UpdateGameStateEvent(GameState.active));
                                  await _gamePausedOverlayController.animateTo(
                                      0,
                                      duration: Duration(milliseconds: 500));

                                  gg.overlays.remove('GamePaused');

                                  _bloc.add(
                                      UpdateGameStateEvent(GameState.active));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFFCCF3DD),
                                      border: Border.all(
                                          width: 3, color: Color(0xFF000000)),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(16),
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Color(0xFF000000),
                                            offset: Offset(6, 6)),
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 56),
                                    child:
                                        SvgPicture.asset(Assets.icons.icoPlay),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
              },
              backgroundBuilder: (context) {
                return Stack(
                  children: [
                    Container(
                      color: Color(0xFF0BB458),
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
