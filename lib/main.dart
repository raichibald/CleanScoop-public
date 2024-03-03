import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc.dart';
import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc_event.dart';
import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc_state.dart';
import 'package:clean_scoop/design_system/src/assets/assets.gen.dart';
import 'package:clean_scoop/design_system/src/assets/fonts.gen.dart';
import 'package:clean_scoop/game/clean_scoop_game.dart';
import 'package:clean_scoop/game/models/game_state.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 800),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.bounceOut,
  );

  late final CleanGrabBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<CleanGrabBloc>();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                'MainMenu': (context, game) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 100),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ScaleTransition(
                              scale: _animation,
                              child: SvgPicture.asset(Assets.icons.icoLogo),
                            )
                          ],
                        ),
                        const Spacer(),
                        ScaleTransition(
                          scale: _animation,
                          child: SvgPicture.asset(Assets.icons.icoMainMenu),
                        ),
                        const Spacer(),
                        ScaleTransition(
                          scale: _animation,
                          child: GestureDetector(
                            onTap: () {
                              final gg = game as TapGame;
                              gg.overlays.add('GameOverlay');
                              _bloc.add(UpdateGameStateEvent(GameState.active));
                              _controller.animateTo(0,
                                  duration: Duration(milliseconds: 500));
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
                                child: SvgPicture.asset(Assets.icons.icoPlay),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
                'GameOverlay': (context, game) {
                  return BlocBuilder<CleanGrabBloc, CleanGrabBlocState>(
                    builder: (context, state) {
                      return SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xFFCCF3DD),
                                            border: Border.all(
                                                width: 4,
                                                color: Color(0xFF000000)),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(50),
                                            ),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Color(0xFF000000),
                                                  offset: Offset(6, 6)),
                                            ]),
                                        width: 112,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 24),
                                          child: Stack(
                                            children: [
                                              Center(
                                                child: Text(
                                                  state.score.toString(),
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    height: 0.7,
                                                    fontWeight: FontWeight.w400,
                                                    decoration:
                                                        TextDecoration.none,
                                                    decorationColor:
                                                        Colors.transparent,
                                                    decorationThickness: 0.01,
                                                    fontFamily: FontFamily.oi,
                                                    foreground: Paint()
                                                      ..style =
                                                          PaintingStyle.stroke
                                                      ..strokeWidth = 6
                                                      ..color =
                                                          Color(0xFF000000),
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Text(
                                                    state.score.toString(),
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      height: 0.7,
                                                      color: Color(0xFF0BB458),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      decoration:
                                                          TextDecoration.none,
                                                      decorationColor:
                                                          Colors.transparent,
                                                      decorationThickness: 0.01,
                                                      fontFamily: FontFamily.oi,
                                                    )),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    left: 16,
                                    child: PlayPauseButton(
                                      isPaused: state.isPaused,
                                      onTap: () => _bloc.add(
                                        UpdateGameStateEvent(
                                          state.isPaused
                                              ? GameState.active
                                              : GameState.paused,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 16,
                                    child: Row(
                                      children: [
                                        AnimatedHeart(
                                            isVisible: state.lives > 2),
                                        AnimatedHeart(
                                            isVisible: state.lives > 1),
                                        AnimatedHeart(
                                            isVisible: state.lives > 0),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    Assets.icons.icoApple,
                                    height: 32,
                                    width: 32,
                                  ),
                                  SvgPicture.asset(
                                    Assets.icons.icoPaperBall,
                                    height: 32,
                                    width: 32,
                                  ),
                                ],
                              )
                            ],
                          ),
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
            // SafeArea(
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 16),
            //     child: unwrappedGame != null
            //         ? Row(
            //             children: [
            //               Text(
            //                 "Score: 24",
            //                 style: TextStyle(
            //                     fontWeight: FontWeight.bold, fontSize: 30),
            //               ),
            //               const Spacer(),
            //               Container(
            //                 color: Colors.green,
            //                 height: 20,
            //                 width: 20,
            //               ),
            //               SizedBox(
            //                 width: 8,
            //               ),
            //               Container(
            //                 color: Colors.green,
            //                 height: 20,
            //                 width: 20,
            //               ),
            //               SizedBox(
            //                 width: 8,
            //               ),
            //               Container(
            //                 color: Colors.green,
            //                 height: 20,
            //                 width: 20,
            //               ),
            //             ],
            //           )
            //         : SizedBox(),
            //   ),
            // ),
            // if (unwrappedGame == null)
            //   Center(
            //     child: CupertinoButton(
            //         child: Text('PLAY'),
            //         onPressed: () {
            //           setState(() {
            //             _game = TapGame();
            //           });
            //         }),
            //   ),
          ],
        ),
      ),
    );
  }
}

class AnimatedHeart extends StatefulWidget {
  final bool isVisible;

  const AnimatedHeart({super.key, required this.isVisible});

  @override
  State<AnimatedHeart> createState() => _AnimatedHeartState();
}

class _AnimatedHeartState extends State<AnimatedHeart> {
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      curve: Curves.bounceIn,
      opacity: widget.isVisible ? 1 : 0,
      duration: const Duration(seconds: 1),
      child: SvgPicture.asset(Assets.icons.icoHeart),
    );
  }
}

class PlayPauseButton extends StatelessWidget {
  final bool isPaused;
  final VoidCallback onTap;

  const PlayPauseButton({
    super.key,
    required this.isPaused,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const icons = Assets.icons;

    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        isPaused ? icons.icoResume : icons.icoPause,
      ),
    );
  }
}
