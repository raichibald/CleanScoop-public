import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc.dart';
import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc_event.dart';
import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc_state.dart';
import 'package:clean_scoop/design_system/src/assets/assets.gen.dart';
import 'package:clean_scoop/design_system/src/widgets/cs_large_button.dart';
import 'package:clean_scoop/game/clean_scoop_game.dart';
import 'package:clean_scoop/game/models/game_state.dart';
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
            const Spacer(),
            ScaleTransition(
              scale: _animation,
              child: Column(
                children: [
                  CSLargeButton(icon: icons.icoRestart, onTap: () {}),
                  const SizedBox(height: 24),
                  CSLargeButton(
                    icon: icons.icoHome,
                    onTap: () {
                      // TODO: Check if need to add animation.
                      final gameRef = widget.game;
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
