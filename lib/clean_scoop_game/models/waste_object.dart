import 'dart:math';

import 'package:clean_scoop/design_system/src/assets/assets.gen.dart';

enum SpawnObject {
  paper(1),
  plasticBottle(2),
  glassBottle(3),
  fruit(4),
  cup(5),
  heart(6),
  poison(7);

  final int value;

  const SpawnObject(this.value);

  factory SpawnObject.fromRawValue(int rawValue) =>
      SpawnObject.values.firstWhere(
        (item) => item.value == rawValue,
        orElse: () => SpawnObject.paper,
      );

  static SpawnObject get randomObject {
    final random = Random();
    final randomInt = random.nextInt(4) + 1;

    return SpawnObject.fromRawValue(randomInt);
  }

  static List<SpawnObject> get wasteObjects => [
        SpawnObject.paper,
        SpawnObject.plasticBottle,
        SpawnObject.glassBottle,
        SpawnObject.fruit,
      ];

  static List<SpawnObject> get threeRandomObjects {
    var objects = wasteObjects.toList();
    objects.shuffle();

    return objects.take(3).toList();
  }

  String get icon {
    const icons = Assets.icons;

    switch (this) {
      case SpawnObject.paper:
        return icons.icoPaperBall;
      case SpawnObject.plasticBottle:
        return icons.icoPlasticBottle;
      case SpawnObject.glassBottle:
        return icons.icoGlassBottle;
      case SpawnObject.fruit:
        return icons.icoApple;
      case SpawnObject.cup:
        return icons.icoCup;
      case SpawnObject.heart:
        return icons.icoHeartLarge;
      case SpawnObject.poison:
        return icons.icoMushroom;
    }
  }

  int get velocityRatio {
    switch (this) {
      case SpawnObject.paper:
        return 1;
      case SpawnObject.plasticBottle:
      case SpawnObject.glassBottle:
      case SpawnObject.poison:
        return 2;
      case SpawnObject.fruit:
      case SpawnObject.cup:
        return 3;
      case SpawnObject.heart:
        return 4;
    }
  }

  double? get weightInKilograms {
    switch (this) {
      case SpawnObject.paper:
        return 0.005;
      case SpawnObject.plasticBottle:
        return 0.012;
      case SpawnObject.glassBottle:
        return 0.2;
      case SpawnObject.fruit:
        return 0.085;
      case SpawnObject.cup:
        // TODO: Implement cup.
        return 3;
      case SpawnObject.poison:
      case SpawnObject.heart:
        return null;
    }
  }
}
