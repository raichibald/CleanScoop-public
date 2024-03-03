import 'dart:async';
import 'dart:math';

import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc.dart';
import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc_state.dart';
import 'package:clean_scoop/clean_grab/bloc/falling_object_component.dart';
import 'package:clean_scoop/clean_grab/bloc/garbage_object.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';

class TapGame extends FlameGame with HasCollisionDetection {
  final CleanGrabBloc _bloc;

  TapGame({required CleanGrabBloc bloc}) : _bloc = bloc;


  @override
  Color backgroundColor() => const Color(0xFFA3EBDE);

  final rand = Random();

  // @override
  // void render(Canvas canvas) {
  //   /// DEBUG
  //   super.render(canvas);
  //   // Draw a crosshair at the expected center of the screen
  //   final paint = Paint()..color = Colors.white;
  //   canvas.drawLine(Vector2(size.x / 2, 0).toOffset(),
  //       Vector2(size.x / 2, size.y).toOffset(), paint);
  //   canvas.drawLine(Vector2(0, size.y / 2).toOffset(),
  //       Vector2(size.x, size.y / 2).toOffset(), paint);
  // }

  @override
  FutureOr<void> onLoad() async {
    // Adding BLoC.
    await add(
      FlameBlocProvider<CleanGrabBloc, CleanGrabBlocState>(
        create: () => _bloc,
        children: [
          ScreenHitbox(),
          SpawnComponent(
            factory: (index) {
              return FallingObjectComponent(
                  garbageObject: GarbageObject.randomObject);
            },
            period: 1.75,
            // area: Rectangle.fromLTWH(rand.nextInt(size.x.toInt()).toDouble(), size.y, FallingObjectComponent.objSize, 0),
            area: Rectangle.fromLTWH(0 + FallingObjectComponent.objSize, size.y,
                size.x - FallingObjectComponent.objSize, 0),
          ),
          // ...
        ],
      ),
    );




    // add(ScreenHitbox());
    // overlays.add('GameOverlay');
    overlays.add('MainMenu');

    // add(
    //   SpawnComponent(
    //     factory: (index) {
    //       return FallingObjectComponent(
    //           garbageObject: GarbageObject.randomObject);
    //     },
    //     period: 0.75,
    //     // area: Rectangle.fromLTWH(rand.nextInt(size.x.toInt()).toDouble(), size.y, FallingObjectComponent.objSize, 0),
    //     area: Rectangle.fromLTWH(0 + FallingObjectComponent.objSize, size.y,
    //         size.x - FallingObjectComponent.objSize, 0),
    //   ),
    // );

    return super.onLoad();
  }

  @override
  bool containsLocalPoint(Vector2 point) =>
      size.toRect().contains(point.toOffset());
}
