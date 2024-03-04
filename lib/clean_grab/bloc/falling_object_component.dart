import 'dart:async';
import 'dart:math';

import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc.dart';
import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc_event.dart';
import 'package:clean_scoop/clean_grab/bloc/clean_grab_bloc_state.dart';
import 'package:clean_scoop/clean_grab/bloc/garbage_object.dart';
import 'package:clean_scoop/game/clean_scoop_game.dart';
import 'package:clean_scoop/game/models/game_state.dart';
import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_svg/flame_svg.dart';

class FallingObjectComponent extends SvgComponent
    with
        CollisionCallbacks,
        TapCallbacks,
        HasGameRef<TapGame>,
        FlameBlocListenable<CleanGrabBloc, CleanGrabBlocState> {
  final double radius;
  final GarbageObject garbageObject;

  FallingObjectComponent({
    super.position,
    this.radius = 30,
    required this.garbageObject,
  }) : super(anchor: Anchor.center);

  static const objSize = 100.0;

  final _velocity = Vector2.zero();
  final _gravity = 200.0;

  final rand = Random();

  bool _hasStartedMovement = false;

  @override
  void onMount() {
    size = Vector2.all(radius * 2);
    super.onMount();
  }

  @override
  FutureOr<void> onLoad() async {
    final svgAsset = await Svg.load(
      garbageObject.icon,
      cache: AssetsCache(prefix: ''),
    );

    svg = svgAsset;

    add(CircleHitbox());

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    final screenHeight = gameRef.size.y;

    // print("??????? ${position.y} -- ${screenHeight}");
    // Increase the initial push upwards more significantly.
    final randomPos = rand.nextInt(251 - 200 + 1) + 200;

    final velocityRatio = garbageObject.velocityRatio; //rand.nextInt(2) + 1;
    // print("??????????? $velocityRatio");
    if (position.y == screenHeight) {
      _velocity.y = -_gravity * velocityRatio -
          randomPos; // Adjust this value to find the right balance.
    }

    // Simplify or adjust the gravity effect
    // This approach uses a constant gravity effect but starts with a stronger initial velocity.
    _velocity.y += _gravity * velocityRatio * dt;

    // Update position with the velocity
    position += _velocity * dt;

    // Optionally, invert velocity at the screen top for a bounce effect.
    if (position.y <= 0) {
      _velocity.y *= -0.5; // Adjust or remove as needed.
    }

    if (!_hasStartedMovement && position.y + objSize < screenHeight) {
      _hasStartedMovement = true;
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);

    if (gameRef.paused) return;

    bloc.add(const UpdateScoreEvent());

    removeFromParent();
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is ScreenHitbox && _hasStartedMovement) {
      bloc.add(const UpdateLivesEvent());
      removeFromParent();
    }
  }

  @override
  void onNewState(CleanGrabBlocState state) {
    super.onNewState(state);

    if (state.gameState == GameState.idle) {
      gameRef.resumeEngine();
      removeFromParent();
    }
  }
}
