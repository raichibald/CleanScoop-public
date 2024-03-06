import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc.dart';
import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc_event.dart';
import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc_state.dart';
import 'package:clean_scoop/design_system/src/assets/assets.gen.dart';
import 'package:clean_scoop/design_system/src/widgets/cs_large_button.dart';
import 'package:clean_scoop/design_system/src/widgets/cs_score_text.dart';
import 'package:clean_scoop/game/clean_scoop_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GameOverOverlay extends StatefulWidget {
  final TapGame game;

  const GameOverOverlay({super.key, required this.game});

  @override
  State<GameOverOverlay> createState() => _GameOverOverlayState();

  static Widget withBloc({
    required TapGame game,
    required CleanGrabBloc bloc,
  }) =>
      BlocProvider.value(
        value: bloc,
        child: GameOverOverlay(game: game),
      );
}

class _GameOverOverlayState extends State<GameOverOverlay>
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

  @override
  void initState() {
    super.initState();
    _controller.forward();
    _bloc = context.read<CleanGrabBloc>();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const icons = Assets.icons;
    final gameRef = widget.game;

    return BlocBuilder<CleanGrabBloc, CleanGrabBlocState>(
      builder: (context, state) => Padding(
        padding: const EdgeInsets.only(top: 100, bottom: 64),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _animation,
                  child: SvgPicture.asset(icons.icoGameOverLogo),
                )
              ],
            ),
            const Spacer(),
            ScaleTransition(
              scale: _animation,
              child: Transform.rotate(
                angle: -0.1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SvgPicture.asset(icons.icoDashedLine),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            CSScoreText(
                              text: state.score.toString(),
                              fontSize: 48,
                              strokeWidth: 8,
                              strokeColor: Colors.black,
                              textColor: const Color(0xFFFFCB0C),
                            ),
                            const Spacer(),
                            const CSScoreText(
                              text: 'score',
                              fontSize: 20,
                              strokeWidth: 0,
                              strokeColor: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      SvgPicture.asset(icons.icoDashedLine),
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Row(
                          children: [
                            CSScoreText(
                              text: '4',
                              fontSize: 48,
                              strokeWidth: 8,
                              strokeColor: Colors.black,
                              textColor: Color(0xFFFF7D75),
                            ),
                            Spacer(),
                            CSScoreText(
                              text: 'earth impact',
                              fontSize: 20,
                              strokeWidth: 0,
                              strokeColor: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      SvgPicture.asset(icons.icoDashedLine),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            Row(
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
                            const Spacer(),
                            const CSScoreText(
                              text: '300g',
                              fontSize: 20,
                              strokeWidth: 0,
                              strokeColor: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            ScaleTransition(
              scale: _animation,
              child: Column(
                children: [
                  CSLargeButton(
                    icon: icons.icoRestart,
                    onTap: () async {
                      await _controller.animateTo(
                        0,
                        duration: const Duration(milliseconds: 500),
                      );

                      gameRef.overlays.remove('GameOver');
                      gameRef.overlays.add('GameControls');
                      _bloc.add(const RestartGameStateEvent());
                      gameRef.overlays.remove('MainMenu');
                    },
                  ),
                  const SizedBox(height: 24),
                  CSLargeButton(
                    icon: icons.icoHome,
                    onTap: () {
                      // TODO: Check if need to add animation.
                      gameRef.overlays.remove('GameOver');
                      gameRef.overlays.add('MainMenu');
                      _bloc.add(const ResetGameStateEvent());
                    },
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
