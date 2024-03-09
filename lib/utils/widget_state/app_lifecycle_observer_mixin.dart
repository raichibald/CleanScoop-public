import 'dart:io';

import 'package:flutter/cupertino.dart';

mixin AppLifecycleObserverMixin<T extends StatefulWidget> on State<T> {
  final _previousAndroidStates = <AppLifecycleState>[];

  late final AppLifecycleListener _appLifecycleListener;

  AppLifecycleState? _previousState;

  void onPausedAppState();

  void onResumedAppState();

  @override
  void initState() {
    super.initState();

    _appLifecycleListener = AppLifecycleListener(
      onStateChange: _onAppLifecycleStateChanged,
    );
  }

  @override
  void dispose() {
    _appLifecycleListener.dispose();

    super.dispose();
  }

  void _onAppLifecycleStateChanged(AppLifecycleState state) {
    // Devices running iOS has slightly different behavior than Android.
    // On iOS when app is not visible / receiving input.
    // Its AppLifecycleState becomes inactive or in some cases paused then inactive.
    // On Android there's no such state.
    final isResumed = state == AppLifecycleState.resumed;
    final isInactive = state == AppLifecycleState.inactive;
    final isHidden = state == AppLifecycleState.hidden;
    final isPaused = state == AppLifecycleState.paused;

    final wasPaused = _previousState == AppLifecycleState.paused;
    final wasInactive = _previousState == AppLifecycleState.inactive;

    // This is used to handle Android app going into background.
    // It helps avoiding repeated occurrence of native location permission dialog.
    // Content of _previousAndroidStates will look like this when resumed.
    // [AppLifecycleState.hidden, AppLifecycleState.inactive, AppLifecycleState.resumed].
    final wasHidden = _previousAndroidStates.contains(
      AppLifecycleState.hidden,
    );

    final wasInBackgroundAndroid =
        Platform.isAndroid && (wasPaused || wasHidden);
    final wasInBackgroundIOS = Platform.isIOS && (wasPaused || wasInactive);

    if (isInactive || isHidden || isPaused) {
      onPausedAppState();
    }

    if (isResumed && (wasInBackgroundIOS || wasInBackgroundAndroid)) {
      onResumedAppState();
    }

    _previousState = state;
    if (_previousAndroidStates.length > 2) {
      _previousAndroidStates.removeAt(0);
    }

    _previousAndroidStates.add(state);
  }
}
