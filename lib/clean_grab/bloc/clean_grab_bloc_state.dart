import 'package:clean_scoop/clean_grab/bloc/garbage_object.dart';
import 'package:clean_scoop/game/models/environment_fact.dart';
import 'package:clean_scoop/game/models/environment_impact_data_mapper.dart';
import 'package:clean_scoop/game/models/game_state.dart';
import 'package:equatable/equatable.dart';

class CollectedObjectData extends Equatable {
  final int count;
  final double weight;

  const CollectedObjectData({
    required this.count,
    required this.weight,
  });

  CollectedObjectData copyWith({int? count, double? weight}) =>
      CollectedObjectData(
        count: count ?? this.count,
        weight: weight ?? this.weight,
      );

  @override
  List<Object?> get props => [
        count,
        weight,
      ];
}

class CleanGrabBlocState extends Equatable {
  final int score;
  final int highScore;
  final int lives;
  final int collectedLives;
  final GameState gameState;
  final List<GarbageObject> collectableWasteObjects;
  final List<GarbageObject> unpickedWasteObjects;
  final EnvironmentFact selectedEnvironmentFact;
  final Map<GarbageObject, CollectedObjectData> collectedObjects;
  final double totalEnergySaved;
  final double totalWaterSaved;
  final double totalCO2Reduced;

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
    List<GarbageObject>? collectableWasteObjects,
    List<GarbageObject>? unpickedWasteObjects,
    EnvironmentFact? selectedEnvironmentFact,
    Map<GarbageObject, CollectedObjectData>? collectedObjects,
    double? totalEnergySaved,
    double? totalWaterSaved,
    double? totalCO2Reduced,
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
      ];
}
