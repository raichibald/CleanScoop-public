import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc_event.dart';
import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc_state.dart';
import 'package:clean_scoop/game/models/game_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class CleanGrabBloc extends Bloc<CleanGrabBlocEvent, CleanGrabBlocState> {
  CleanGrabBloc()
      : super(
          const CleanGrabBlocState(
            score: 0,
            lives: 3,
            gameState: GameState.idle,
            collectableWasteObjects: [],
          ),
        ) {
    on<UpdateScoreEvent>(_onUpdateScoreEvent);
    on<UpdateLivesEvent>(_onUpdateLivesEvent);
    on<UpdateGameStateEvent>(_onUpdateGameStateEvent);
    on<UpdateCollectableWasteObjectsEvent>(
      _onUpdateCollectableWasteObjectsEvent,
    );
    on<ResetGameStateEvent>(_onResetGameStateEvent);
  }

  void _onUpdateScoreEvent(UpdateScoreEvent event, Emitter emit) {
    emit(state.copyWith(score: state.score + 1));
  }

  void _onUpdateLivesEvent(UpdateLivesEvent event, Emitter emit) {
    print("?????? ${state.lives}");
    // TODO: Emit "Game Over" state.
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
    emit(state.copyWith());
  }

  void _onResetGameStateEvent(ResetGameStateEvent event, Emitter emit) => emit(
        state.copyWith(
          score: 0,
          lives: 3,
          gameState: GameState.idle,
          collectableWasteObjects: [],
        ),
      );
}
