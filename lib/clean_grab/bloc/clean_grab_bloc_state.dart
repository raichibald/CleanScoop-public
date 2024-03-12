import 'package:clean_scoop/game/models/waste_object.dart';
import 'package:clean_scoop/clean_grab/models/collected_object_data.dart';
import 'package:clean_scoop/game_overlay/models/environment_fact.dart';
import 'package:clean_scoop/game_overlay/models/game_state.dart';
import 'package:equatable/equatable.dart';

class CleanGrabBlocState extends Equatable {
  final int score;
  final int highScore;
  final int lives;
  final int collectedLives;
  final GameState gameState;
  final List<WasteObject> collectableWasteObjects;
  final List<WasteObject> unpickedWasteObjects;
  final EnvironmentFact selectedEnvironmentFact;
  final Map<WasteObject, CollectedObjectData> collectedObjects;
  final double totalEnergySaved;
  final double totalWaterSaved;
  final double totalCO2Reduced;
  final double totalWeightCollected;

  const CleanGrabBlocState({
    required this.score,
    required this.highScore,
    required this.lives,
    required this.collectedLives,
    required this.gameState,
    required this.collectableWasteObjects,
    required this.unpickedWasteObjects,
    required this.selectedEnvironmentFact,
    required this.collectedObjects,
    required this.totalEnergySaved,
    required this.totalWaterSaved,
    required this.totalCO2Reduced,
    required this.totalWeightCollected,
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

  bool get canSpawnLives => lives < 3 && collectedLives < 3;

  CleanGrabBlocState copyWith({
    int? score,
    int? highScore,
    int? lives,
    int? collectedLives,
    GameState? gameState,
    List<WasteObject>? collectableWasteObjects,
    List<WasteObject>? unpickedWasteObjects,
    EnvironmentFact? selectedEnvironmentFact,
    Map<WasteObject, CollectedObjectData>? collectedObjects,
    double? totalEnergySaved,
    double? totalWaterSaved,
    double? totalCO2Reduced,
    double? totalWeightCollected,
  }) =>
      CleanGrabBlocState(
        score: score ?? this.score,
        highScore: highScore ?? this.highScore,
        lives: lives ?? this.lives,
        collectedLives: collectedLives ?? this.collectedLives,
        gameState: gameState ?? this.gameState,
        collectableWasteObjects:
            collectableWasteObjects ?? this.collectableWasteObjects,
        unpickedWasteObjects: unpickedWasteObjects ?? this.unpickedWasteObjects,
        selectedEnvironmentFact:
            selectedEnvironmentFact ?? this.selectedEnvironmentFact,
        collectedObjects: collectedObjects ?? this.collectedObjects,
        totalEnergySaved: totalEnergySaved ?? this.totalEnergySaved,
        totalWaterSaved: totalWaterSaved ?? this.totalWaterSaved,
        totalCO2Reduced: totalCO2Reduced ?? this.totalCO2Reduced,
        totalWeightCollected: totalWeightCollected ?? this.totalWeightCollected,
      );

  @override
  List<Object?> get props => [
        score,
        highScore,
        lives,
        collectedLives,
        gameState,
        collectableWasteObjects,
        unpickedWasteObjects,
        selectedEnvironmentFact,
        collectedObjects,
        totalEnergySaved,
        totalWaterSaved,
        totalCO2Reduced,
        totalWeightCollected,
      ];
}
