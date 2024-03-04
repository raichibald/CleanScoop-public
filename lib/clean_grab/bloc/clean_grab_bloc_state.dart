import 'package:clean_scoop/clean_grab/bloc/garbage_object.dart';
import 'package:clean_scoop/game/models/game_state.dart';
import 'package:equatable/equatable.dart';

class CleanGrabBlocState extends Equatable {
  final int score;
  final int lives;
  final GameState gameState;
  final List<GarbageObject> collectableWasteObjects;

  const CleanGrabBlocState({
    required this.score,
    required this.lives,
    required this.gameState,
    required this.collectableWasteObjects,
  });

  bool get isPaused =>
      gameState == GameState.idle || gameState == GameState.paused;

  bool get hasEnded => gameState == GameState.ended;

  CleanGrabBlocState copyWith({
    int? score,
    int? lives,
    GameState? gameState,
    List<GarbageObject>? collectableWasteObjects,
  }) =>
      CleanGrabBlocState(
        score: score ?? this.score,
        lives: lives ?? this.lives,
        gameState: gameState ?? this.gameState,
        collectableWasteObjects:
            collectableWasteObjects ?? this.collectableWasteObjects,
      );

  @override
  List<Object?> get props => [
        score,
        lives,
        gameState,
        collectableWasteObjects,
      ];
}
