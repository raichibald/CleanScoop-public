import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:clean_scoop/clean_scoop_game/bloc/clean_grab_bloc.dart';
import 'package:clean_scoop/clean_scoop_game/bloc/clean_grab_bloc_event.dart';
import 'package:clean_scoop/clean_scoop_game/bloc/clean_grab_bloc_state.dart';
import 'package:clean_scoop/clean_scoop_game/game/clean_scoop_game.dart';
import 'package:clean_scoop/clean_scoop_game/models/waste_object.dart';
import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/particles.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FallingObjectComponent extends SvgComponent
    with
        CollisionCallbacks,
        TapCallbacks,
        HasGameRef<CleanScoopGame>,
        FlameBlocListenable<CleanScoopBloc, CleanScoopBlocState> {
  final double radius;
  final WasteObject garbageObject;

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

  late final _particlePaint = Paint()..color = const Color(0xFFCCF3DD);

  static final _random = Random();

  static Vector2 _randomVector(double scale) {
    return Vector2(2 * _random.nextDouble() - 1, 2 * _random.nextDouble() - 1)
      ..normalize()
      ..scale(scale);
  }

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
    final screenWidth = gameRef.size.x;

    // print("??????? ${position.y} -- ${screenHeight}");
    // Increase the initial push upwards more significantly.
    final randomPos = rand.nextInt(251 - 200 + 1) + 200;

    final velocityRatio = garbageObject.velocityRatio; //rand.nextInt(2) + 1;
    // print("??????????? $velocityRatio");
    if (position.y == screenHeight) {
      _velocity.y = -_gravity * velocityRatio -
          randomPos; // Adjust this value to find the right balance.
    }

    // Not letting object fall outside of the horizontal screen bounds.
    if (position.x < 35 || position.x > screenWidth - 35) {
      _velocity.x *= -1;
      position.x = position.x.clamp(25, screenWidth - 25);
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
      _velocity.x = randomXPosInt / screenHeight * _velocity.y.abs();
      _hasStartedMovement = true;
    }
  }

  int get randomXPosInt {
    var rand = Random();
    int randomNumber;

    // Decide which range to use: 50% chance for each
    if (rand.nextBool()) {
      // Generate a number from -40 to -20
      randomNumber = rand.nextInt(61) -
          100; // Generates a number from 0 to 20, then shifts it to -40 to -20
    } else {
      // Generate a number from 20 to 40
      randomNumber = rand.nextInt(61) +
          100; // Generates a number from 0 to 20, then shifts it to 20 to 40
    }

    return randomNumber;
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);

    if (gameRef.paused) return;
    if (garbageObject == WasteObject.heart ||
        bloc.state.collectableWasteObjects.contains(garbageObject)) {
      HapticFeedback.heavyImpact();
    } else {
      HapticFeedback.vibrate();
    }
    bloc.add(UpdateScoreEvent(garbageObject));

    removeFromParent();

    _displayParticleEffect();
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (!isMounted) return;
    if (other is ScreenHitbox && _hasStartedMovement) {
      if (bloc.state.collectableWasteObjects.contains(garbageObject)) {
        HapticFeedback.vibrate();
      }

      bloc.add(UpdateLivesEvent(garbageObject));
      removeFromParent();
    }
  }

  @override
  void onNewState(CleanScoopBlocState state) {
    super.onNewState(state);

    if (state.isIdle) {
      gameRef.resumeEngine();
      removeFromParent();
    }

    if (state.hasEnded || state.hasLeveledUp) {
      removeFromParent();
    }
  }

  void _displayParticleEffect() {
    addAll([
      OpacityEffect.fadeOut(
        LinearEffectController(0.1),
        onComplete: removeFromParent,
      ),
      ScaleEffect.by(
        Vector2.all(1.2),
        LinearEffectController(0.1),
      ),
    ]);

    parent?.add(
      ParticleSystemComponent(
        position: position,
        particle: Particle.generate(
          count: 30,
          lifespan: 1,
          generator: (index) => MovingParticle(
            to: _randomVector(16),
            child: ScalingParticle(
              to: 0,
              child: CircleParticle(
                radius: 2 + rand.nextDouble() * 3,
                paint: _particlePaint,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
