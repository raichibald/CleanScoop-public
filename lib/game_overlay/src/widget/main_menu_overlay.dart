import 'package:clean_scoop/clean_scoop_game/clean_scoop_game.dart';
import 'package:clean_scoop/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainMenuOverlay extends StatefulWidget {
  final CleanScoopGame game;

  const MainMenuOverlay({super.key, required this.game});

  @override
  State<MainMenuOverlay> createState() => _MainMenuOverlayState();
}

class _MainMenuOverlayState extends State<MainMenuOverlay>
    with TickerProviderStateMixin {
  late final CleanGrabBloc _bloc;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 800),
    vsync: this,
  );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.bounceOut,
  );

  late final AnimationController _alertController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );

  late final Animation<double> _alertAnimation = CurvedAnimation(
    parent: _alertController,
    curve: Curves.fastLinearToSlowEaseIn,
  );

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
    const icons = Assets.icons;

    return BlocBuilder<CleanGrabBloc, CleanGrabBlocState>(
      builder: (context, state) {
        final isFactDisplayed = state.isEnvironmentFactDisplayed;

        return Padding(
          padding: const EdgeInsets.only(top: 100, bottom: 64),
          child: Stack(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ScaleTransition(
                        scale: _animation,
                        child: SvgPicture.asset(icons.icoLogo),
                      )
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 268,
                    height: 297,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          child: ScaleTransition(
                            scale: _animation,
                            child: _MainMenuWasteObject(
                              icon: icons.icoPlasticBottleWeight,
                              onTap: () {
                                if (isFactDisplayed) return;

                                _bloc.add(
                                  const SetSelectedEnvironmentFactEvent(
                                    EnvironmentFact.plastic,
                                  ),
                                );
                                _alertController.forward();
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          top: 60,
                          right: 0,
                          child: ScaleTransition(
                            scale: _animation,
                            child: _MainMenuWasteObject(
                              icon: icons.icoPaperBallWeight,
                              onTap: () {
                                if (isFactDisplayed) return;

                                _bloc.add(
                                  const SetSelectedEnvironmentFactEvent(
                                    EnvironmentFact.paper,
                                  ),
                                );
                                _alertController.forward();
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          top: 122,
                          left: 44,
                          child: ScaleTransition(
                            scale: _animation,
                            child: _MainMenuWasteObject(
                              icon: icons.icoAppleWeight,
                              onTap: () {
                                if (isFactDisplayed) return;

                                _bloc.add(
                                  const SetSelectedEnvironmentFactEvent(
                                    EnvironmentFact.organic,
                                  ),
                                );
                                _alertController.forward();
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          top: 200,
                          right: 0,
                          child: ScaleTransition(
                            scale: _animation,
                            child: _MainMenuWasteObject(
                              icon: icons.icoGlassBottleWeight,
                              onTap: () {
                                if (isFactDisplayed) return;

                                _bloc.add(
                                  const SetSelectedEnvironmentFactEvent(
                                    EnvironmentFact.glass,
                                  ),
                                );
                                _alertController.forward();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  ScaleTransition(
                    scale: _animation,
                    child: Column(
                      children: [
                        CSLargeIconButton(
                          icon: icons.icoPlay,
                          onTap: () async {
                            await _alertController.animateTo(
                              0,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.fastLinearToSlowEaseIn,
                            );
                            _bloc.add(
                              const SetSelectedEnvironmentFactEvent(
                                EnvironmentFact.none,
                              ),
                            );
                            _bloc.add(const LoadHighScoreEvent());

                            await _controller.animateTo(
                              0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.fastLinearToSlowEaseIn,
                            );

                            final gameRef = widget.game;
                            gameRef.overlays.add('GameControls');
                            _bloc.add(
                                const UpdateGameStateEvent(GameState.started));
                            _bloc.add(
                                const UpdateCollectableWasteObjectsEvent());
                            gameRef.overlays.remove('MainMenu');
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
              CSCustomDialog(
                animation: _alertAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Did you know?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        height: 0.7,
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        decoration: TextDecoration.none,
                        decorationColor: Colors.transparent,
                        decorationThickness: 0.01,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.selectedEnvironmentFact.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.2,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                        decorationColor: Colors.transparent,
                        decorationThickness: 0.01,
                        // fontFamily: FontFamily.oi,
                      ),
                    ),
                  ],
                ),
                onCloseTap: () async {
                  await _alertController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.fastLinearToSlowEaseIn,
                  );

                  _bloc.add(
                    const SetSelectedEnvironmentFactEvent(
                      EnvironmentFact.none,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MainMenuWasteObject extends StatefulWidget {
  final String icon;
  final VoidCallback onTap;

  const _MainMenuWasteObject({required this.icon, required this.onTap});

  @override
  State<_MainMenuWasteObject> createState() => _MainMenuWasteObjectState();
}

class _MainMenuWasteObjectState extends State<_MainMenuWasteObject> {
  var _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.8 : 1,
      duration: const Duration(milliseconds: 150),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: SvgPicture.asset(widget.icon),
      ),
    );
  }
}
