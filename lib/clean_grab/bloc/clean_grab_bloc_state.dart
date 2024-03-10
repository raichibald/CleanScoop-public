import 'package:clean_scoop/clean_grab/bloc/garbage_object.dart';
import 'package:clean_scoop/game/models/environment_fact.dart';
import 'package:clean_scoop/game/models/game_state.dart';
import 'package:equatable/equatable.dart';

class CleanGrabBlocState extends Equatable {
  final int score;
  final int highScore;
  final int lives;
  final GameState gameState;
  final List<GarbageObject> collectableWasteObjects;
  final List<GarbageObject> unpickedWasteObjects;
  final EnvironmentFact selectedEnvironmentFact;

  const CleanGrabBlocState({
    required this.score,
    required this.highScore,
    required this.lives,
    required this.gameState,
    required this.collectableWasteObjects,
    required this.unpickedWasteObjects,
    required this.selectedEnvironmentFact,
  });

  bool get isPaused =>
      gameState == GameState.idle || gameState == GameState.paused;

  bool get hasEnded => gameState == GameState.ended;

  bool get hasLeveledUp => gameState == GameState.levelUp;

  bool get isActive => gameState == GameState.active;

  bool get hasStarted => gameState == GameState.started;

  bool get isIdle => gameState == GameState.idle;

  bool get isEnvironmentFactDisplayed =>
      selectedEnvironmentFact != EnvironmentFact.none;

  CleanGrabBlocState copyWith({
    int? score,
    int? highScore,
    int? lives,
    GameState? gameState,
    List<GarbageObject>? collectableWasteObjects,
    List<GarbageObject>? unpickedWasteObjects,
    EnvironmentFact? selectedEnvironmentFact,
  }) =>
      CleanGrabBlocState(
        score: score ?? this.score,
        highScore: highScore ?? this.highScore,
        lives: lives ?? this.lives,
        gameState: gameState ?? this.gameState,
        collectableWasteObjects:
            collectableWasteObjects ?? this.collectableWasteObjects,
        unpickedWasteObjects: unpickedWasteObjects ?? this.unpickedWasteObjects,
        selectedEnvironmentFact:
            selectedEnvironmentFact ?? this.selectedEnvironmentFact,
      );

  @override
  List<Object?> get props => [
        score,
        highScore,
        lives,
        gameState,
        collectableWasteObjects,
        unpickedWasteObjects,
        selectedEnvironmentFact,
      ];
}
