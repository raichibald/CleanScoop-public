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
    final updatedLives = isObjective ? lives : lives - 1;

    var currentCollectibles = state.collectableWasteObjects.toList();
    // Removing initial waste object from unpicked list.
    var unpickedCollectibles = state.unpickedWasteObjects.toList();
    final initialWasteObject = currentCollectibles.firstOrNull;

    if (unpickedCollectibles.contains(initialWasteObject)) {
      unpickedCollectibles.remove(initialWasteObject);
    }

    final previousScore = state.score;
    final updatedScore = isObjective ? previousScore + 1 : previousScore;

    // We only want max 3 out of 4 objects to be collectible so that player needs to think :).
    if (updatedScore % 5 == 0 &&
        previousScore != updatedScore &&
        currentCollectibles.length < GarbageObject.values.length - 1) {
      final random = Random();
      final randomInt = random.nextInt(unpickedCollectibles.length);
      final randomWasteObject = unpickedCollectibles[randomInt];

      currentCollectibles.add(randomWasteObject);
      unpickedCollectibles.remove(randomWasteObject);
    }

    emit(
      state.copyWith(
        score: updatedScore,
        lives: updatedLives,
        collectableWasteObjects: currentCollectibles,
        unpickedWasteObjects: unpickedCollectibles,
      ),
    );
  }

  void _onUpdateLivesEvent(UpdateLivesEvent event, Emitter emit) {
    if (!state.collectableWasteObjects.contains(event.object)) return;

    final lives = state.lives;
    if (lives < 1) return;

    emit(state.copyWith(lives: lives - 1));
  }

  void _onUpdateGameStateEvent(UpdateGameStateEvent event, Emitter emit) {
    emit(state.copyWith(gameState: event.state));
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

  void _onRestartGameStateEvent(RestartGameStateEvent event, Emitter emit) =>
      emit(
        state.copyWith(
          score: 0,
          lives: 3,
          gameState: GameState.active,
          collectableWasteObjects: [GarbageObject.randomObject],
          unpickedWasteObjects: GarbageObject.values,
        ),
      );
}
