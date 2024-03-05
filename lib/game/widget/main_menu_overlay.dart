import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc.dart';
import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc_event.dart';
import 'package:clean_scoop/design_system/src/assets/assets.gen.dart';
import 'package:clean_scoop/design_system/src/widgets/cs_large_button.dart';
import 'package:clean_scoop/game/clean_scoop_game.dart';
import 'package:clean_scoop/game/models/game_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainMenuOverlay extends StatefulWidget {
  final TapGame game;

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

    return Padding(
      padding: const EdgeInsets.only(top: 100, bottom: 64),
      child: Column(
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
                      onTap: () {},
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
                      onTap: () {},
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
                      onTap: () {},
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
                      onTap: () {},
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
                CSLargeButton(
                  icon: icons.icoPlay,
                  onTap: () async {
                    await _controller.animateTo(
                      0,
                      duration: const Duration(milliseconds: 500),
                    );

                    final gameRef = widget.game;
                    gameRef.overlays.add('GameControls');
                    _bloc.add(const UpdateGameStateEvent(GameState.active));
                    _bloc.add(const UpdateCollectableWasteObjectsEvent());
                    gameRef.overlays.remove('MainMenu');
                  },
                ),
              ],
            ),
          )
        ],
      ),
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
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: SvgPicture.asset(widget.icon),
      ),
    );
  }
}
