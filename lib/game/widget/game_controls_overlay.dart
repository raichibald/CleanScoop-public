import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc.dart';
import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc_event.dart';
import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc_state.dart';
import 'package:clean_scoop/design_system/src/assets/assets.gen.dart';
import 'package:clean_scoop/design_system/src/widgets/cs_score_text.dart';
import 'package:clean_scoop/game/clean_scoop_game.dart';
import 'package:clean_scoop/game/models/game_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GameControlsOverlay extends StatefulWidget {
  final TapGame game;

  const GameControlsOverlay({super.key, required this.game});

  @override
  State<GameControlsOverlay> createState() => _GameControlsOverlayState();

  static Widget withBloc({
    required TapGame game,
    required CleanGrabBloc bloc,
  }) =>
      BlocProvider.value(
        value: bloc,
        child: GameControlsOverlay(game: game),
      );
}

class _GameControlsOverlayState extends State<GameControlsOverlay>
    with TickerProviderStateMixin {
  late final CleanGrabBloc _bloc;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<CleanGrabBloc>();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<CleanGrabBloc, CleanGrabBlocState>(
        builder: (context, state) => Stack(
          children: [
            // TODO: Leaving for now, just in case I change my mind. :)
            // IgnorePointer(
            //   ignoring: !state.hasLeveledUp,
            //   child: AnimatedOpacity(
            //     opacity: state.hasStarted || state.hasLeveledUp ? 1 : 0,
            //     duration: const Duration(milliseconds: 150),
            //     child: Container(color: Colors.white.withOpacity(0.5)),
            //   ),
            // ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: AnimatedOpacity(
                  opacity:
                      state.hasStarted || state.isActive || state.hasLeveledUp
                          ? 1
                          : 0,
                  duration: const Duration(milliseconds: 150),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFCCF3DD),
                                      border: Border.all(
                                        width: 4,
                                        color: const Color(0xFF000000),
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(50),
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Color(0xFF000000),
                                            offset: Offset(6, 6)),
                                      ],
                                    ),
                                    width: 112,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 24),
                                      child: CSScoreText(
                                        text: state.score.toString(),
                                        fontSize: 24,
                                        strokeWidth: 6,
                                        strokeColor: Colors.black,
                                        textColor: const Color(0xFF0BB458),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                left: 16,
                                child: GestureDetector(
                                  onTap: () async {
                                    if (state.isPaused) return;

                                    final gameRef = widget.game;
                                    gameRef.overlays.add('GamePaused');
                                    _bloc.add(
                                      const UpdateGameStateEvent(
                                        GameState.paused,
                                      ),
                                    );

                                    await _controller.animateTo(
                                      0,
                                      duration:
                                          const Duration(milliseconds: 500),
                                    );
                                  },
                                  child: AnimatedScale(
                                    scale: state.hasStarted || state.isPaused || state.hasLeveledUp
                                        ? 0
                                        : 1,
                                    duration: const Duration(milliseconds: 150),
                                    child: SvgPicture.asset(
                                      Assets.icons.icoPause,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 16,
                                child: Row(
                                  children: [
                                    _AnimatedHeart(isVisible: state.lives > 2),
                                    _AnimatedHeart(isVisible: state.lives > 1),
                                    _AnimatedHeart(isVisible: state.lives > 0),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      AnimatedPositioned(
                        left: 0,
                        top: state.hasLeveledUp || state.hasStarted
                            ? MediaQuery.sizeOf(context).height / 2 - 128
                            : 90,
                        right: 0,
                        duration: const Duration(milliseconds: 500),
                        child: AnimatedScale(
                          scale: state.hasLeveledUp || state.hasStarted ? 3 : 1,
                          duration: const Duration(milliseconds: 500),
                          child: Column(
                            children: [
                              AnimatedScale(
                                scale: state.hasStarted ? 1 : 0,
                                duration: const Duration(milliseconds: 300),
                                child: const CSScoreText(
                                  text: 'recycle',
                                  fontSize: 11,
                                  strokeWidth: 4,
                                  strokeColor: Colors.white,
                                ),
                              ),
                              AnimatedScale(
                                scale: state.hasLeveledUp ? 1 : 0,
                                duration: const Duration(milliseconds: 300),
                                child: const CSScoreText(
                                  text: 'level up',
                                  fontSize: 11,
                                  strokeWidth: 3,
                                  strokeColor: Colors.white,
                                ),
                              ),
                              SizedBox(
                                  height: state.hasLeveledUp || state.hasStarted
                                      ? 8
                                      : 0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: state.collectableWasteObjects
                                    .map(
                                      (item) => SvgPicture.asset(
                                        item.icon,
                                        height: 32,
                                        width: 32,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class _AnimatedHeart extends StatefulWidget {
  final bool isVisible;

  const _AnimatedHeart({required this.isVisible});

  @override
  State<_AnimatedHeart> createState() => _AnimatedHeartState();
}

class _AnimatedHeartState extends State<_AnimatedHeart> {
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
