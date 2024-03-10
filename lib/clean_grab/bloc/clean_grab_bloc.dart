import 'dart:math';

import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc_event.dart';
import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc_state.dart';
import 'package:clean_scoop/clean_grab/bloc/garbage_object.dart';
import 'package:clean_scoop/game/models/environment_fact.dart';
import 'package:clean_scoop/game/models/game_state.dart';
import 'package:clean_scoop/score/score_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CleanGrabBloc extends Bloc<CleanGrabBlocEvent, CleanGrabBlocState> {
  final ScoreRepository _scoreRepository;

  CleanGrabBloc({required ScoreRepository scoreRepository})
      : _scoreRepository = scoreRepository,
        super(
          CleanGrabBlocState(
            score: 0,
            highScore: 0,
            lives: 3,
            collectedLives: 0,
            gameState: GameState.idle,
            collectableWasteObjects: [GarbageObject.randomObject],
            unpickedWasteObjects: GarbageObject.wasteObjects,
            selectedEnvironmentFact: EnvironmentFact.none,
          ),
        ) {
    on<LoadHighScoreEvent>(_onLoadHighScoreEvent);
    on<UpdateScoreEvent>(_onUpdateScoreEvent);
    on<UpdateLivesEvent>(_onUpdateLivesEvent);
    on<UpdateGameStateEvent>(_onUpdateGameStateEvent);
    on<UpdateCollectableWasteObjectsEvent>(
      _onUpdateCollectableWasteObjectsEvent,
    );
    on<ResetGameStateEvent>(_onResetGameStateEvent);
    on<RestartGameStateEvent>(_onRestartGameStateEvent);
    on<SetSelectedEnvironmentFactEvent>(_onSetSelectedEnvironmentFactEvent);
  }

  Future<void> _onLoadHighScoreEvent(
    LoadHighScoreEvent event,
    Emitter emit,
  ) async {
    final highScore = await _scoreRepository.playerHighScore;

    emit(state.copyWith(highScore: highScore));
  }

  void _onUpdateScoreEvent(UpdateScoreEvent event, Emitter emit) {
    final previousScore = state.score;

    if (event.object == GarbageObject.poison) {
      emit(
        state.copyWith(
          lives: 0,
          gameState: GameState.ended,
        ),
      );

      _scoreRepository.setPlayerHighScore(previousScore);

      return;
    }

    if (event.object == GarbageObject.heart && state.collectedLives < 3) {
      print("???????? dafuq");
      emit(
        state.copyWith(
          lives: state.lives + 1,
          collectedLives: state.collectedLives + 1,
        ),
      );

      return;
    }

    final isObjective = state.collectableWasteObjects.contains(event.object);
    final isLevelingUp = state.hasLeveledUp;
    final lives = state.lives;
    final updatedLives = isObjective || isLevelingUp ? lives : lives - 1;

    if (updatedLives < 1) {
      _scoreRepository.setPlayerHighScore(previousScore);

      emit(state.copyWith(lives: updatedLives, gameState: GameState.ended));

      return;
    }

    var currentCollectibles = state.collectableWasteObjects.toList();
    // Removing initial waste object from unpicked list.
    var unpickedCollectibles = state.unpickedWasteObjects.toList();
    final initialWasteObject = currentCollectibles.firstOrNull;

    if (unpickedCollectibles.contains(initialWasteObject)) {
      unpickedCollectibles.remove(initialWasteObject);
    }

    final updatedScore = isObjective ? previousScore + 1 : previousScore;

    // We only want max 3 out of 4 objects to be collectible so that player needs to think :).
    // TODO: Looks OK, but maybe revisit.
    final division = updatedScore <= 7
        ? 7
        : updatedScore <= 20
            ? 20
            : updatedScore <= 45
                ? 35
                : 25;

    if (updatedScore % division == 0 && previousScore != updatedScore) {
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
    if (!state.collectableWasteObjects.contains(event.object) ||
        state.hasLeveledUp) return;

    final updatedLives = state.lives - 1;
    if (updatedLives < 1) {
      _scoreRepository.setPlayerHighScore(state.score);

      emit(state.copyWith(lives: updatedLives, gameState: GameState.ended));
      return;
    }

    emit(state.copyWith(lives: updatedLives));
  }

  Future<void> _onUpdateGameStateEvent(
    UpdateGameStateEvent event,
    Emitter emit,
  ) async {
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
        collectableWasteObjects: [GarbageObject.randomObject],
        unpickedWasteObjects: GarbageObject.values,
      ),
    );

    add(const UpdateGameStateEvent(GameState.started));
  }

  void _onSetSelectedEnvironmentFactEvent(
    SetSelectedEnvironmentFactEvent event,
    Emitter emit,
  ) =>
      emit(
        state.copyWith(
          selectedEnvironmentFact: event.fact,
        ),
      );
}
