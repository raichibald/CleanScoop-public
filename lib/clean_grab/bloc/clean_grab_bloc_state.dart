import 'package:clean_scoop/game/models/game_state.dart';
import 'package:equatable/equatable.dart';

class CleanGrabBlocState extends Equatable {
  final int score;
  final int lives;
  final GameState gameState;

  const CleanGrabBlocState({
    required this.score,
    required this.lives,
    required this.gameState,
  });

  bool get isPaused =>
      gameState == GameState.idle || gameState == GameState.paused;

  CleanGrabBlocState copyWith({
    int? score,
    int? lives,
    GameState? gameState,
  }) =>
      CleanGrabBlocState(
        score: score ?? this.score,
        lives: lives ?? this.lives,
        gameState: gameState ?? this.gameState,
      );

  @override
  List<Object?> get props => [
        score,
        lives,
        gameState,
      ];
}
