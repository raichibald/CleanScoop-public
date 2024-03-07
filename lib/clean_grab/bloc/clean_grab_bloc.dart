import 'dart:math';

import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc_event.dart';
import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc_state.dart';
import 'package:clean_scoop/clean_grab/bloc/garbage_object.dart';
import 'package:clean_scoop/game/models/game_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CleanGrabBloc extends Bloc<CleanGrabBlocEvent, CleanGrabBlocState> {
  CleanGrabBloc()
      : super(
          CleanGrabBlocState(
            score: 0,
            lives: 3,
            gameState: GameState.idle,
            collectableWasteObjects: [GarbageObject.randomObject],
            unpickedWasteObjects: GarbageObject.values,
          ),
        ) {
    on<UpdateScoreEvent>(_onUpdateScoreEvent);
    on<UpdateLivesEvent>(_onUpdateLivesEvent);
    on<UpdateGameStateEvent>(_onUpdateGameStateEvent);
    on<UpdateCollectableWasteObjectsEvent>(
      _onUpdateCollectableWasteObjectsEvent,
    );
    on<ResetGameStateEvent>(_onResetGameStateEvent);
    on<RestartGameStateEvent>(_onRestartGameStateEvent);
  }

  void _onUpdateScoreEvent(UpdateScoreEvent event, Emitter emit) {
    final lives = state.lives;
    if (lives < 1) return;

    final isObjective = state.collectableWasteObjects.contains(event.object);
    final isLevelingUp = state.hasLeveledUp;
    final updatedLives = isObjective || isLevelingUp ? lives : lives - 1;

    var currentCollectibles = state.collectableWasteObjects.toList();
    // Removing initial waste object from unpicked list.
    var unpickedCollectibles = state.unpickedWasteObjects.toList();
    final initialWasteObject = currentCollectibles.firstOrNull;

    if (unpickedCollectibles.contains(initialWasteObject)) {
      unpickedCollectibles.remove(initialWasteObject);
    }

    final previousScore = state.score;
    final updatedScore = isObjective ? previousScore + 1 : previousScore;

    var gameState = state.gameState;

    // We only want max 3 out of 4 objects to be collectible so that player needs to think :).
    // TODO: Looks OK, but maybe revisit.
    final division = updatedScore <= 7 ? 7 : updatedScore <= 20 ? 20 : updatedScore <= 45 ? 35 : 25;

    if (updatedScore % division == 0 &&
        previousScore != updatedScore) {
      emit(state.copyWith(gameState: GameState.levelUp));

      if (currentCollectibles.length == 3) {
        currentCollectibles = GarbageObject.threeRandomObjects;
      } else {
        final random = Random();
        final randomInt = random.nextInt(unpickedCollectibles.length);
        final randomWasteObject = unpickedCollectibles[randomInt];

        currentCollectibles.add(randomWasteObject);
        unpickedCollectibles.remove(randomWasteObject);
      }
    }

    emit(
      state.copyWith(
        score: updatedScore,
        lives: updatedLives,
        collectableWasteObjects: currentCollectibles,
        unpickedWasteObjects: unpickedCollectibles,
        // gameState: gameState,
      ),
    );
  }

  void _onUpdateLivesEvent(UpdateLivesEvent event, Emitter emit) {
    if (!state.collectableWasteObjects.contains(event.object) || state.hasLeveledUp) return;

    final lives = state.lives;
    if (lives < 1) return;

    emit(state.copyWith(lives: lives - 1));
  }

  Future<void> _onUpdateGameStateEvent(UpdateGameStateEvent event, Emitter emit) async {
    final gameState = event.state;
    if (gameState == GameState.started) {
      await Future.delayed(const Duration(milliseconds: 200));
      emit(state.copyWith(gameState: gameState));
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(gameState: GameState.active));
    } else {
      emit(state.copyWith(gameState: gameState));
    }
  }

  void _onUpdateCollectableWasteObjectsEvent(
    UpdateCollectableWasteObjectsEvent event,
    Emitter emit,
  ) {
    emit(state.copyWith(collectableWasteObjects: [GarbageObject.randomObject]));
  }

  void _onResetGameStateEvent(ResetGameStateEvent event, Emitter emit) => emit(
        state.copyWith(
          score: 0,
          lives: 3,
          gameState: GameState.idle,
          collectableWasteObjects: [],
          unpickedWasteObjects: GarbageObject.values,
        ),
      );

  void _onRestartGameStateEvent(RestartGameStateEvent event, Emitter emit) {
    emit(
        state.copyWith(
          score: 0,
          lives: 3,
          // gameState: GameState.started,
          collectableWasteObjects: [GarbageObject.randomObject],
          unpickedWasteObjects: GarbageObject.values,
        ),
      );

    add(const UpdateGameStateEvent(GameState.started));
  }
}
