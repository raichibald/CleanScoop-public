import 'package:clean_scoop/key_value_storage/key_value_storage.dart';
import 'package:clean_scoop/score/score_repository.dart';

class AppScoreRepository extends ScoreRepository {
  final KeyValueStorage _storage;

  AppScoreRepository({required KeyValueStorage storage}) : _storage = storage;

  static const _kPlayerScore = 'key.player_score';

  @override
  Future<void> setPlayerHighScore(int score) async {
    final currentHighScore = await playerHighScore;
    if (currentHighScore > score) return;

    _storage.setInt(_kPlayerScore, score);
  }

  @override
  Future<int> get playerHighScore async =>
      await _storage.getInt(_kPlayerScore) ?? 0;
}
