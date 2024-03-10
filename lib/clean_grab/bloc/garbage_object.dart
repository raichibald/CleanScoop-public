import 'dart:math';

import 'package:clean_scoop/design_system/src/assets/assets.gen.dart';

enum GarbageObject {
  paper(1),
  plasticBottle(2),
  glassBottle(3),
  fruit(4),
  cup(5),
  heart(6),
  poison(7);

  final int value;

  const GarbageObject(this.value);

  factory GarbageObject.fromRawValue(int rawValue) =>
      GarbageObject.values.firstWhere(
        (item) => item.value == rawValue,
        orElse: () => GarbageObject.paper,
      );

  static GarbageObject get randomObject {
    final random = Random();
    final randomInt = random.nextInt(4) + 1;

    return GarbageObject.fromRawValue(randomInt);
  }

  static List<GarbageObject> get wasteObjects {
    // final resolvedObjects = GarbageObject.values.where(
    //   (item) => item != GarbageObject.poison && item != GarbageObject.heart,
    // );
    final resolvedObjects = [
      GarbageObject.paper,
      GarbageObject.plasticBottle,
      GarbageObject.glassBottle,
      GarbageObject.fruit,
    ];

    return resolvedObjects.toList();
  }

  static List<GarbageObject> get threeRandomObjects {
    var objects = wasteObjects.toList();
    objects.shuffle();

    return objects.take(3).toList();
  }

  String get icon {
    const icons = Assets.icons;

    switch (this) {
      case GarbageObject.paper:
        return icons.icoPaperBall;
      case GarbageObject.plasticBottle:
        return icons.icoPlasticBottle;
      case GarbageObject.glassBottle:
        return icons.icoGlassBottle;
      case GarbageObject.fruit:
        return icons.icoApple;
      case GarbageObject.cup:
        return icons.icoCup;
      case GarbageObject.heart:
        return icons.icoHeartLarge;
      case GarbageObject.poison:
        return icons.icoMushroom;
    }
  }

  int get velocityRatio {
    switch (this) {
      case GarbageObject.paper:
        return 1;
      case GarbageObject.plasticBottle:
      case GarbageObject.glassBottle:
      case GarbageObject.poison:
        return 2;
      case GarbageObject.fruit:
      case GarbageObject.cup:
        return 3;
      case GarbageObject.heart:
        return 4;
    }
  }
}
