import 'package:clean_scoop/clean_scoop_game/models/environment_fact.dart';
import 'package:clean_scoop/clean_scoop_game/models/game_state.dart';
import 'package:clean_scoop/clean_scoop_game/models/waste_object.dart';
import 'package:equatable/equatable.dart';

sealed class CleanScoopBlocEvent extends Equatable {
  const CleanScoopBlocEvent();

  @override
  List<Object?> get props => [];
}

final class LoadHighScoreEvent extends CleanScoopBlocEvent {
  const LoadHighScoreEvent();
}

final class UpdateScoreEvent extends CleanScoopBlocEvent {
  final SpawnObject object;

  const UpdateScoreEvent(this.object);

  @override
  List<Object?> get props => [object];
}

final class UpdateLivesEvent extends CleanScoopBlocEvent {
  final SpawnObject object;

  const UpdateLivesEvent(this.object);

  @override
  List<Object?> get props => [object];
}

final class UpdateGameStateEvent extends CleanScoopBlocEvent {
  final GameState state;

  const UpdateGameStateEvent(this.state);

  @override
  List<Object?> get props => [state];
}

final class UpdateCollectableWasteObjectsEvent extends CleanScoopBlocEvent {
  const UpdateCollectableWasteObjectsEvent();
}

final class ResetGameStateEvent extends CleanScoopBlocEvent {
  const ResetGameStateEvent();
}

final class RestartGameStateEvent extends CleanScoopBlocEvent {
  const RestartGameStateEvent();
}

final class SetSelectedEnvironmentFactEvent extends CleanScoopBlocEvent {
  final EnvironmentFact fact;

  const SetSelectedEnvironmentFactEvent(this.fact);

  @override
  List<Object?> get props => [fact];
}
