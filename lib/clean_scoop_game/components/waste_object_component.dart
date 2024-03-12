import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:clean_scoop/clean_scoop_game/bloc/clean_scoop_bloc.dart';
import 'package:clean_scoop/clean_scoop_game/bloc/clean_scoop_bloc_event.dart';
import 'package:clean_scoop/clean_scoop_game/bloc/clean_scoop_bloc_state.dart';
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

class WasteObjectComponent extends SvgComponent
    with
        CollisionCallbacks,
        TapCallbacks,
        HasGameRef<CleanScoopGame>,
        FlameBlocListenable<CleanScoopBloc, CleanScoopBlocState> {
  final double radius;
  final WasteObject garbageObject;

  WasteObjectComponent({
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

    final gameSize = gameRef.size;
    final screenHeight = gameSize.y;
    final screenWidth = gameSize.x;

    final randomPos = rand.nextInt(251 - 200 + 1) + 200;

    // TODO: Check if generating random velocity ratio makes more sense.
    final velocityRatio = garbageObject.velocityRatio;
    if (position.y == screenHeight) {
      _velocity.y = -_gravity * velocityRatio - randomPos;
    }

    if (position.x < 35 || position.x > screenWidth - 35) {
      _velocity.x *= -1;
      position.x = position.x.clamp(25, screenWidth - 25);
    }

    _velocity.y += _gravity * velocityRatio * dt;
    position += _velocity * dt;

    if (!_hasStartedMovement && position.y + objSize < screenHeight) {
      _velocity.x = randomXPosInt / screenHeight * _velocity.y.abs();
      _hasStartedMovement = true;
    }
  }

  int get randomXPosInt {
    final rand = Random();
    int randomNumber;

    if (rand.nextBool()) {
      randomNumber = rand.nextInt(61) - 100;
    } else {
      randomNumber = rand.nextInt(61) + 100;
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
