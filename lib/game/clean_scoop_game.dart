import 'dart:async';
import 'dart:math';

import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc.dart';
import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc_event.dart';
import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc_state.dart';
import 'package:clean_scoop/clean_grab/bloc/falling_object_component.dart';
import 'package:clean_scoop/clean_grab/bloc/garbage_object.dart';
import 'package:clean_scoop/game/models/game_state.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';

class TapGame extends FlameGame with HasCollisionDetection {
  final CleanGrabBloc _bloc;

  TapGame({required CleanGrabBloc bloc}) : _bloc = bloc;

  late final SpawnComponent _wasteObjectSpawner;

  late final FlameBlocProvider _blocProvider;

  @override
  Color backgroundColor() => const Color(0xFFA3EBDE);

  final rand = Random();

  // @override
  // void render(Canvas canvas) {
  //   /// DEBUG
  //   super.render(canvas);
  //   // Draw a crosshair at the expected center of the screen
  //   final paint = Paint()..color = Colors.white;
  //   canvas.drawLine(Vector2(size.x / 2, 0).toOffset(),
  //       Vector2(size.x / 2, size.y).toOffset(), paint);
  //   canvas.drawLine(Vector2(0, size.y / 2).toOffset(),
  //       Vector2(size.x, size.y / 2).toOffset(), paint);
  // }

  @override
  FutureOr<void> onLoad() async {
    _blocProvider = FlameBlocProvider<CleanGrabBloc, CleanGrabBlocState>.value(
      value: _bloc,
      children: [
        ScreenHitbox(),
        CleanScoopGameWrapperComponent(),
      ],
    );

    add(_blocProvider);

    _wasteObjectSpawner = SpawnComponent.periodRange(
      factory: (index) {
        return FallingObjectComponent(
            garbageObject: GarbageObject.randomObject);
      },
      minPeriod: 0.55,
      maxPeriod: 1,
      autoStart: false,
      area: Rectangle.fromLTWH(
        FallingObjectComponent.objSize / 2,
        size.y,
        size.x - FallingObjectComponent.objSize,
        0,
      ),
    );

    _blocProvider.add(_wasteObjectSpawner);

    // add(_wasteObjectSpawner);

    // add(ScreenHitbox());
    // overlays.add('GameOverlay');
    overlays.add('MainMenu');

    return super.onLoad();
  }

  void startSpawningComponents() {
    _wasteObjectSpawner.timer.start();
  }

  void stopSpawningComponents() {
    _wasteObjectSpawner.timer.stop();
  }

  @override
  bool containsLocalPoint(Vector2 point) =>
      size.toRect().contains(point.toOffset());
}

class CleanScoopGameWrapperComponent extends PositionComponent
    with
        FlameBlocListenable<CleanGrabBloc, CleanGrabBlocState>,
        HasGameRef<TapGame> {
  var _hasSpawned = false;

  @override
  void onNewState(CleanGrabBlocState state) {
    super.onNewState(state);

    if (!state.isPaused && !_hasSpawned) {
      _hasSpawned = true;
      gameRef.startSpawningComponents();
    }

    if (state.gameState == GameState.idle) {
      _hasSpawned = false;
      gameRef.stopSpawningComponents();
    }

    if (state.lives == 0) {
      gameRef.stopSpawningComponents();
      bloc.add(const UpdateGameStateEvent(GameState.ended));
      gameRef.overlays.add('GameOver');
      gameRef.overlays.remove('GameControls');
      _hasSpawned = false;
    }

    if (state.isPaused) {
      gameRef.pauseEngine();
    } else {
      gameRef.resumeEngine();
    }
  }
}
