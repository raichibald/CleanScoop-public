import 'dart:async';

import 'package:clean_scoop/clean_scoop_game/bloc/clean_scoop_bloc.dart';
import 'package:clean_scoop/clean_scoop_game/bloc/clean_scoop_bloc_event.dart';
import 'package:clean_scoop/clean_scoop_game/bloc/clean_scoop_bloc_state.dart';
import 'package:clean_scoop/clean_scoop_game/components/spawn_object_component.dart';
import 'package:clean_scoop/clean_scoop_game/models/game_state.dart';
import 'package:clean_scoop/clean_scoop_game/models/waste_object.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';

class CleanScoopGame extends FlameGame with HasCollisionDetection {
  final CleanScoopBloc _bloc;

  CleanScoopGame({required CleanScoopBloc bloc}) : _bloc = bloc;

  late final SpawnComponent _wasteObjectSpawner;
  late final SpawnComponent _poisonObjectSpawner;
  late final SpawnComponent _lifeObjectSpawner;

  late final FlameBlocProvider _blocProvider;

  @override
  Color backgroundColor() => const Color(0xFFA3EBDE);

  @override
  FutureOr<void> onLoad() async {
    final spawnArea = Rectangle.fromLTWH(
      SpawnObjectComponent.objSize / 2,
      size.y,
      size.x - SpawnObjectComponent.objSize,
      0,
    );

    _blocProvider =
        FlameBlocProvider<CleanScoopBloc, CleanScoopBlocState>.value(
      value: _bloc,
      children: [
        ScreenHitbox(),
        CleanScoopGameWrapperComponent(),
      ],
    );

    add(_blocProvider);

    _wasteObjectSpawner = SpawnComponent.periodRange(
      factory: (index) => SpawnObjectComponent(
        garbageObject: SpawnObject.randomObject,
      ),
      minPeriod: 0.35,
      maxPeriod: 0.5,
      autoStart: false,
      area: spawnArea,
    );

    _poisonObjectSpawner = SpawnComponent.periodRange(
      factory: (index) => SpawnObjectComponent(
        garbageObject: SpawnObject.poison,
      ),
      minPeriod: 5,
      maxPeriod: 10,
      autoStart: false,
      area: spawnArea,
    );

    _lifeObjectSpawner = SpawnComponent.periodRange(
      factory: (index) => SpawnObjectComponent(
        garbageObject: SpawnObject.heart,
      ),
      minPeriod: 5,
      maxPeriod: 10,
      autoStart: false,
      area: spawnArea,
    );

    _blocProvider.add(_poisonObjectSpawner);
    _blocProvider.add(_wasteObjectSpawner);
    _blocProvider.add(_lifeObjectSpawner);

    overlays.add('MainMenu');

    return super.onLoad();
  }

  void startSpawningComponents() {
    _wasteObjectSpawner.timer.start();
    _poisonObjectSpawner.timer.start();
  }

  void stopSpawningComponents() {
    _wasteObjectSpawner.timer.stop();
    _poisonObjectSpawner.timer.stop();
  }

  void startSpawningLives() {
    _lifeObjectSpawner.timer.start();
  }

  void stopSpawningLives() {
    _lifeObjectSpawner.timer.stop();
  }

  @override
  bool containsLocalPoint(Vector2 point) =>
      size.toRect().contains(point.toOffset());
}

class CleanScoopGameWrapperComponent extends PositionComponent
    with
        FlameBlocListenable<CleanScoopBloc, CleanScoopBlocState>,
        HasGameRef<CleanScoopGame> {
  var _hasSpawned = false;
  var _hasSpawnedLives = false;

  @override
  void onNewState(CleanScoopBlocState state) async {
    super.onNewState(state);

    if (state.isActive && !_hasSpawned) {
      _hasSpawned = true;
      gameRef.startSpawningComponents();
    }

    if (state.gameState == GameState.idle) {
      _hasSpawned = false;
      _hasSpawnedLives = false;

      gameRef.stopSpawningComponents();
      gameRef.stopSpawningLives();
    }

    if (state.isActive && !_hasSpawnedLives && state.canSpawnLives) {
      _hasSpawnedLives = true;
      gameRef.startSpawningLives();
    }

    if (!state.canSpawnLives) {
      gameRef.stopSpawningLives();
    }

    if (state.lives == 0) {
      gameRef.stopSpawningComponents();
      gameRef.stopSpawningLives();

      bloc.add(const UpdateGameStateEvent(GameState.ended));
      gameRef.overlays.add('GameOver');
      gameRef.overlays.remove('GameControls');
      _hasSpawned = false;
      _hasSpawnedLives = false;
    }

    if (state.isPaused) {
      gameRef.pauseEngine();
    } else {
      gameRef.resumeEngine();
    }

    if (state.gameState == GameState.levelUp) {
      _hasSpawned = false;
      _hasSpawnedLives = false;

      gameRef.stopSpawningComponents();
      gameRef.stopSpawningLives();

      await Future.delayed(const Duration(seconds: 3)).then(
        (value) => bloc.add(
          const UpdateGameStateEvent(GameState.active),
        ),
      );
    }
  }
}
