import 'package:equatable/equatable.dart';

class CleanGrabBlocState extends Equatable {
  final int score;
  final int lives;

  const CleanGrabBlocState({
    required this.score,
    required this.lives,
  });

  CleanGrabBlocState copyWith({
    int? score,
    int? lives,
  }) =>
      CleanGrabBlocState(
        score: score ?? this.score,
        lives: lives ?? this.lives,
      );

  @override
  List<Object?> get props => [
        score,
        lives,
      ];
}
