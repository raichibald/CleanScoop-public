import 'dart:async';

import 'package:clean_scoop/app/widget/app.dart';
import 'package:clean_scoop/key_value_storage/key_value_storage.dart';
import 'package:clean_scoop/score/app_score_repository.dart';
import 'package:clean_scoop/score/score_repository.dart';
import 'package:clean_scoop/shared_preferences_key_value_storage/shared_preferences_key_value_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    final sharedPreferences = await SharedPreferences.getInstance();
    final storage = SharedPreferencesKeyValueStorage(
      sharedPreferences,
    );

    runApp(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<KeyValueStorage>(
            create: (context) => storage,
          ),
          RepositoryProvider<ScoreRepository>(
            create: (context) => AppScoreRepository(
              storage: storage,
            ),
          ),
        ],
        child: App.withBloc(),
      ),
    );
  }, (error, stack) {
    // TODO: Handle app crash
  });
}
