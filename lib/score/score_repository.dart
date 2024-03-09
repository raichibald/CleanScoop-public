abstract class ScoreRepository {
  Future<void> setPlayerHighScore(int score);

  Future<int> get playerHighScore;
}
