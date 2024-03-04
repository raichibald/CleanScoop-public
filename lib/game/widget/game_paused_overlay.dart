import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc.dart';
import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc_event.dart';
import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc_state.dart';
import 'package:clean_scoop/design_system/src/assets/assets.gen.dart';
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

    return BlocBuilder<CleanGrabBloc, CleanGrabBlocState>(
      builder: (context, state) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 100),
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
            const Spacer(),
            ScaleTransition(
              scale: _animation,
              child: GestureDetector(
                onTap: () async {
                  await _controller.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                  );

                  _bloc.add(const UpdateGameStateEvent(GameState.active));
                  widget.game.overlays.remove('GamePaused');
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFCCF3DD),
                      border: Border.all(
                        width: 3,
                        color: const Color(0xFF000000),
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF000000),
                          offset: Offset(6, 6),
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 56,
                    ),
                    child: SvgPicture.asset(icons.icoPlay),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
