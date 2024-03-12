import 'package:clean_scoop/game/models/garbage_object.dart';
import 'package:clean_scoop/game_overlay/models/environment_fact.dart';
import 'package:clean_scoop/game_overlay/models/game_state.dart';
import 'package:equatable/equatable.dart';

sealed class CleanGrabBlocEvent extends Equatable {
  const CleanGrabBlocEvent();

  @override
  List<Object?> get props => [];
}

final class LoadHighScoreEvent extends CleanGrabBlocEvent {
  const LoadHighScoreEvent();
}

final class UpdateScoreEvent extends CleanGrabBlocEvent {
  final GarbageObject object;

  const UpdateScoreEvent(this.object);

  @override
  List<Object?> get props => [object];
}

final class UpdateLivesEvent extends CleanGrabBlocEvent {
  final GarbageObject object;

  const UpdateLivesEvent(this.object);

  @override
  List<Object?> get props => [object];
}

final class UpdateGameStateEvent extends CleanGrabBlocEvent {
  final GameState state;

  const UpdateGameStateEvent(this.state);

  @override
  List<Object?> get props => [state];
}

final class UpdateCollectableWasteObjectsEvent extends CleanGrabBlocEvent {
  const UpdateCollectableWasteObjectsEvent();
}

final class ResetGameStateEvent extends CleanGrabBlocEvent {
  const ResetGameStateEvent();
}

final class RestartGameStateEvent extends CleanGrabBlocEvent {
  const RestartGameStateEvent();
}

final class SetSelectedEnvironmentFactEvent extends CleanGrabBlocEvent {
  final EnvironmentFact fact;

  const SetSelectedEnvironmentFactEvent(this.fact);

  @override
  List<Object?> get props => [fact];
}
