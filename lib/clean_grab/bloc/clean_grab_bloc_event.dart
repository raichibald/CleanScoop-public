import 'package:clean_scoop/game/models/game_state.dart';
import 'package:equatable/equatable.dart';

sealed class CleanGrabBlocEvent extends Equatable {
  const CleanGrabBlocEvent();

  @override
  List<Object?> get props => [];
}

final class UpdateScoreEvent extends CleanGrabBlocEvent {
  const UpdateScoreEvent();
}

final class UpdateLivesEvent extends CleanGrabBlocEvent {
  const UpdateLivesEvent();
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
