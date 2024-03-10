import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc.dart';
import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc_event.dart';
import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc_state.dart';
import 'package:clean_scoop/design_system/src/assets/assets.gen.dart';
import 'package:clean_scoop/design_system/src/widgets/cs_large_icon_button.dart';
import 'package:clean_scoop/design_system/src/widgets/cs_score_text.dart';
import 'package:clean_scoop/game/clean_scoop_game.dart';
import 'package:clean_scoop/game/models/game_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GamePausedOverlay extends StatefulWidget {
  final TapGame game;

  const GamePausedOverlay({super.key, required this.game});

  @override
  State<GamePausedOverlay> createState() => _GamePausedOverlayState();

  static Widget withBloc({
    required TapGame game,
    required CleanGrabBloc bloc,
  }) =>
      BlocProvider.value(
        value: bloc,
        child: GamePausedOverlay(game: game),
      );
}

class _GamePausedOverlayState extends State<GamePausedOverlay>
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

  late final AnimationController _backdropController = AnimationController(
    duration: const Duration(milliseconds: 400),
    vsync: this,
  );

  late final Animation<Color?> _backdropColor = ColorTween(
    begin: Colors.transparent,
    end: Colors.white.withOpacity(0.5),
  ).animate(_backdropController);

  @override
  void initState() {
    super.initState();
    _controller.forward();
    _backdropController.forward();
    _bloc = context.read<CleanGrabBloc>();
  }

  @override
  void dispose() {
    _controller.dispose();
    _backdropController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const icons = Assets.icons;

    final gameRef = widget.game;

    return BlocBuilder<CleanGrabBloc, CleanGrabBlocState>(
      builder: (context, state) => AnimatedBuilder(
        animation: _backdropController,
        builder: (context, child) {
          return Container(
            color: _backdropColor.value,
            child: Padding(
              padding: const EdgeInsets.only(top: 100, bottom: 64),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ScaleTransition(
                        scale: _animation,
                        child: SvgPicture.asset(icons.icoGamePausedLogo),
                      )
                    ],
                  ),
                  const Spacer(),
                  ScaleTransition(
                    scale: _animation,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: state.collectableWasteObjects
                          .map(
                            (item) => SvgPicture.asset(
                              item.icon,
                              width: 100,
                              height: 100,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const Spacer(),
                  ScaleTransition(
                    scale: _animation,
                    child: CSScoreText(
                      text: state.score.toString(),
                      fontSize: 64,
                      strokeWidth: 8,
                      strokeColor: Colors.black,
                      textColor: const Color(0xFFFFCB0C),
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
                            await _controller.animateTo(
                              0,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.fastLinearToSlowEaseIn,
                            );

                            await _backdropController.animateTo(
                              0,
                              duration: const Duration(milliseconds: 200),
                            );

                            _bloc.add(
                                const UpdateGameStateEvent(GameState.active));
                            gameRef.overlays.remove('GamePaused');
                          },
                        ),
                        const SizedBox(height: 24),
                        CSLargeIconButton(
                          icon: icons.icoHome,
                          onTap: () async {
                            // TODO: Check if need to add animation.
                            gameRef.overlays.remove('GamePaused');
                            gameRef.overlays.add('MainMenu');
                            _bloc.add(const ResetGameStateEvent());
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
