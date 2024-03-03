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
