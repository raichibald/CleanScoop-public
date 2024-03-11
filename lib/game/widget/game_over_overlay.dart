import 'dart:math';

import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc.dart';
import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc_event.dart';
import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc_state.dart';
import 'package:clean_scoop/design_system/src/assets/assets.gen.dart';
import 'package:clean_scoop/design_system/src/widgets/cs_custom_dialog.dart';
import 'package:clean_scoop/design_system/src/widgets/cs_large_icon_button.dart';
import 'package:clean_scoop/design_system/src/widgets/cs_large_text_button.dart';
import 'package:clean_scoop/design_system/src/widgets/cs_score_text.dart';
import 'package:clean_scoop/game/clean_scoop_game.dart';
import 'package:clean_scoop/utils/extension/double_extension.dart';
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

  late final AnimationController _alertController = AnimationController(
    duration: const Duration(milliseconds: 800),
    vsync: this,
  );

  late final Animation<double> _alertAnimation = CurvedAnimation(
    parent: _alertController,
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
        child: Stack(
          children: [
            Column(
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
                const SizedBox(height: 48),
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
                                          height: 40,
                                          width: 40,
                                        ),
                                      )
                                      .toList(),
                                ),
                                const Spacer(),
                                const CSScoreText(
                                  text: '300g',
                                  fontSize: 20,
                                  strokeWidth: 0,
                                ),
                              ],
                            ),
                          ),
                          if (state.collectedObjects.isNotEmpty)
                            CSLargeTextButton(
                              title: 'SEE YOUR IMPACT',
                              onTap: () => _alertController.forward(),
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
                      CSLargeIconButton(
                        icon: icons.icoRestart,
                        onTap: () async {
                          await _alertController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.fastLinearToSlowEaseIn,
                          );
                          _bloc.add(const LoadHighScoreEvent());
                          await _controller.animateTo(
                            0,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.fastLinearToSlowEaseIn,
                          );

                          gameRef.overlays.remove('GameOver');
                          gameRef.overlays.add('GameControls');
                          _bloc.add(const RestartGameStateEvent());
                          gameRef.overlays.remove('MainMenu');
                        },
                      ),
                      const SizedBox(height: 24),
                      CSLargeIconButton(
                        icon: icons.icoHome,
                        onTap: () async {
                          // TODO: Check if need to add animation.
                          await _alertController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.fastLinearToSlowEaseIn,
                          );
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
            CSCustomDialog(
              animation: _alertAnimation,
              child: Column(
                children: [
                  const Text(
                    'ENVIRONMENTAL\nIMPACT',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      height: 1.2,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      decoration: TextDecoration.none,
                      decorationColor: Colors.transparent,
                      decorationThickness: 0.01,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: state.collectedObjects.entries
                        .map(
                          (item) => Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      item.value.count.toString(),
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        height: 1.2,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        decoration: TextDecoration.none,
                                        decorationColor: Colors.transparent,
                                        decorationThickness: 0.01,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  SvgPicture.asset(
                                    item.key.icon,
                                    height: 40,
                                    width: 40,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      '${item.value.weight.formattedDouble}kg',
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        height: 1.2,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        decoration: TextDecoration.none,
                                        decorationColor: Colors.transparent,
                                        decorationThickness: 0.01,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SvgPicture.asset(icons.icoDashedLineGrey),
                              const SizedBox(height: 16),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        if (state.totalEnergySaved > 0)
                          _EnvironmentalImpactRow(
                              icon: icons.icoEnergy,
                              title: 'Energy Saved',
                              value:
                                  '${state.totalEnergySaved.formattedDouble} kWh'),
                        const SizedBox(height: 8),
                        if (state.totalWaterSaved > 0)
                          _EnvironmentalImpactRow(
                              icon: icons.icoWater,
                              title: 'Water Saved',
                              value:
                                  '${state.totalWaterSaved.formattedDouble} liters'),
                        const SizedBox(height: 8),
                        if (state.totalCO2Reduced > 0)
                          _EnvironmentalImpactRow(
                              icon: icons.icoEmissions,
                              title: 'CO2 Reduction',
                              value:
                                  '${state.totalCO2Reduced.formattedDouble} kg'),
                      ],
                    ),
                  ),
                ],
              ),
              onCloseTap: () {
                _alertController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.fastLinearToSlowEaseIn,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _EnvironmentalImpactRow extends StatelessWidget {
  final String icon;
  final String title;
  final String value;

  const _EnvironmentalImpactRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(icon),
        const SizedBox(width: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                height: 1.2,
                color: Colors.black,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.none,
                decorationColor: Colors.transparent,
                decorationThickness: 0.01,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                height: 1.2,
                color: Color(0xFF0BB458),
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.none,
                decorationColor: Colors.transparent,
                decorationThickness: 0.01,
              ),
            ),
          ],
        )
      ],
    );
  }
}

// TODO: Temporary. Don't like this.
class EnvironmentalImpact {
  static get randomEnvironmentalMessage {
    final random = Random();
    final randomInt = random.nextInt(10) + 1;

    return '\n ${environmentalImpact[randomInt]} \n\n ${recyclingTips[randomInt]}';
  }

  static const Map<int, String> environmentalImpact = {
    1: "Equivalent Trees Planted: Planting {X} trees can absorb approximately {Y} kg of CO2 annually.",
    2: "Water Saved by Recycling Paper: Recycling {X} kg of paper saves approximately {Y} liters of water.",
    3: "Energy Conserved by Recycling: Recycling {X} kg of plastic saves {Y} kWh of energy.",
    4: "Wildlife Protected by Reducing Plastic Waste: By collecting {X} plastic items, you've potentially saved {Y} marine animals from harm.",
    5: "Landfill Space Saved: You've saved {X} cubic meters of landfill space.",
    6: "Pollution Reduction from Recycling Metals: Recycling {X} kg of metal reduces air pollution by {Y} kg.",
    7: "Energy Saved by Recycling Glass: Recycling {X} kg of glass saves {Y} kWh of energy.",
    8: "Greenhouse Gas Emissions Avoided: You've avoided {Y} kg of greenhouse gas emissions by recycling {X} kg of waste.",
    9: "Energy Saved by Recycling Aluminum: Recycling {X} aluminum cans saves {Y} kWh of energy.",
    10: "Reduced Need for Raw Materials: Recycling {X} kg of materials reduces the need for {Y} kg of raw materials."
  };

  static const Map<int, String> recyclingTips = {
    1: "Start a recycling station at home: Set up separate bins for paper, plastics, metals, and glass to make recycling easier and more efficient.",
    2: "Familiarize yourself with local recycling rules to ensure you're recycling correctly and not contaminating the recycling stream.",
    3: "Try to reduce waste and reuse items before recycling. It's the most effective way to minimize environmental impact.",
    4: "Find local e-waste recycling programs for your old electronics. They contain valuable materials that can be reused.",
    5: "Start composting at home to recycle kitchen scraps and yard waste, turning them into valuable fertilizer for your garden.",
    6: "Share your knowledge and encourage friends and family to start recycling. Collective effort makes a big difference.",
    7: "oin or organize local events to clean up neighborhoods, parks, and beaches, recycling what you collect.",
    8: "Support the recycling industry and encourage the market for recycled goods by choosing them whenever possible.",
    9: "Opt for reusable alternatives to single-use plastic items, which are often difficult to recycle and harmful to the environment.",
    10: "Batteries, paint, and chemicals should never go in regular recycling. Look for special disposal options to handle them safely."
  };
}
