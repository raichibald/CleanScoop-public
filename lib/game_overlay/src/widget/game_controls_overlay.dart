import 'dart:math';

import 'package:clean_scoop/clean_scoop_game/clean_scoop_game.dart';
import 'package:clean_scoop/design_system/design_system.dart';
import 'package:clean_scoop/utils/widget_state/app_lifecycle_observer_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GameControlsOverlay extends StatefulWidget {
  final CleanScoopGame game;

  const GameControlsOverlay({super.key, required this.game});

  @override
  State<GameControlsOverlay> createState() => _GameControlsOverlayState();

  static Widget withBloc({
    required CleanScoopGame game,
    required CleanGrabBloc bloc,
  }) =>
      BlocProvider.value(
        value: bloc,
        child: GameControlsOverlay(game: game),
      );
}

class _GameControlsOverlayState extends State<GameControlsOverlay>
    with TickerProviderStateMixin, AppLifecycleObserverMixin {
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
        builder: (context, state) {
          final score = state.score.toString();
          final highScore = state.highScore;

          return Stack(
            children: [
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
                                Stack(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 24),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFCCF3DD),
                                              border: Border.all(
                                                width: 4,
                                                color: const Color(0xFF000000),
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 24),
                                              child: AnimatedSwitcher(
                                                duration: const Duration(
                                                    milliseconds: 200),
                                                transitionBuilder:
                                                    (child, animation) {
                                                  return ScaleTransition(
                                                    scale: Tween<double>(
                                                      begin: 0,
                                                      end: 1,
                                                    ).animate(animation),
                                                    child: child,
                                                  );
                                                },
                                                child: CSScoreText(
                                                  key: ValueKey<String>(
                                                    score,
                                                  ),
                                                  text: score,
                                                  fontSize: 24,
                                                  strokeWidth: 6,
                                                  strokeColor: Colors.black,
                                                  textColor: const Color(
                                                    0xFF0BB458,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (highScore > 0)
                                      Positioned(
                                        left: 0,
                                        top: 68,
                                        right: 0,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              Assets.icons.icoStar,
                                              width: 16,
                                              height: 16,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            CSScoreText(
                                              text: highScore.toString(),
                                              fontSize: 24,
                                              strokeWidth: 4,
                                              strokeColor: Colors.black,
                                              textColor:
                                                  const Color(0xFFFFCB0C),
                                              shadows: const [
                                                BoxShadow(
                                                  color: Color(0xFF000000),
                                                  offset: Offset(4, 4),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            SvgPicture.asset(
                                              Assets.icons.icoStar,
                                              width: 16,
                                              height: 16,
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                Positioned(
                                  left: 16,
                                  child: GestureDetector(
                                    onTap: () => _onPauseGame(state.isPaused),
                                    child: AnimatedScale(
                                      scale: state.hasStarted ||
                                              state.isPaused ||
                                              state.hasLeveledUp
                                          ? 0
                                          : 1,
                                      duration:
                                          const Duration(milliseconds: 150),
                                      child: SvgPicture.asset(
                                        Assets.icons.icoPause,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 16,
                                  child: _PlayerLivesBlock(lives: state.lives),
                                ),
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
                            scale:
                                state.hasLeveledUp || state.hasStarted ? 3 : 1,
                            duration: const Duration(milliseconds: 500),
                            child: Column(
                              children: [
                                AnimatedScale(
                                  scale: state.hasStarted ? 1 : 0,
                                  duration: const Duration(milliseconds: 300),
                                  child: const CSScoreText(
                                    text: 'tap',
                                    fontSize: 11,
                                    strokeWidth: 2,
                                    strokeColor: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: state.hasLeveledUp || state.hasStarted
                                      ? 8
                                      : 0,
                                ),
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
                                SizedBox(
                                  height: state.hasLeveledUp || state.hasStarted
                                      ? 16
                                      : 0,
                                ),
                                AnimatedScale(
                                  scale: state.hasStarted ? 1 : 0,
                                  duration: const Duration(milliseconds: 300),
                                  child: const CSScoreText(
                                    text: 'to recycle',
                                    fontSize: 11,
                                    strokeWidth: 2,
                                    strokeColor: Colors.white,
                                  ),
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
          );
        },
      );

  @override
  void onPausedAppState() {
    // TODO: For now, pausing only when state is `GameState.active`.
    _onPauseGame(_bloc.state.gameState == GameState.started);
  }

  @override
  void onResumedAppState() {
    // Do nothing, as we want user to manually resume the game.
  }

  void _onPauseGame(bool isPaused) async {
    if (isPaused) return;

    final gameRef = widget.game;
    gameRef.overlays.add('GamePaused');
    _bloc.add(const UpdateGameStateEvent(GameState.paused));

    await _controller.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
    );
  }
}

class _PlayerLivesBlock extends StatefulWidget {
  final int lives;

  const _PlayerLivesBlock({required this.lives});

  @override
  State<_PlayerLivesBlock> createState() => _PlayerLivesBlockState();
}

class _PlayerLivesBlockState extends State<_PlayerLivesBlock>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _animation = Tween(
      begin: 0.0,
      end: 6.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const _ShakeCurve(count: 3),
      ),
    );

    _controller.addListener(_animationListener);
  }

  @override
  void didUpdateWidget(covariant _PlayerLivesBlock oldWidget) {
    super.didUpdateWidget(oldWidget);

    final completedAnimation = !_controller.isAnimating;
    final shouldShake = completedAnimation &&
        widget.lives > 0 &&
        widget.lives < oldWidget.lives;

    if (!shouldShake) return;

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lives = widget.lives;

    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_animation.value, 0),
            child: Row(
              children: [
                _AnimatedHeart(isVisible: lives > 2),
                _AnimatedHeart(isVisible: lives > 1),
                _AnimatedHeart(isVisible: lives > 0),
              ],
            ),
          );
        });
  }

  void _animationListener() {
    if (!_controller.isCompleted) return;

    _controller.reset();
  }
}

class _AnimatedHeart extends StatelessWidget {
  final bool isVisible;

  const _AnimatedHeart({required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      curve: Curves.bounceIn,
      opacity: isVisible ? 1 : 0,
      duration: const Duration(seconds: 1),
      child: SvgPicture.asset(Assets.icons.icoHeart),
    );
  }
}

class _ShakeCurve extends Curve {
  final int count;

  const _ShakeCurve({required this.count});

  @override
  double transform(double t) => sin(count * pi * t);
}
