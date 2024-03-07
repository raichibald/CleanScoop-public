import 'dart:math';

import 'package:clean_scoop/design_system/src/assets/assets.gen.dart';

enum GarbageObject {
  paper(1),
  plasticBottle(2),
  glassBottle(3),
  fruit(4);

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

  static List<GarbageObject> get threeRandomObjects {
    var objects = GarbageObject.values.toList();
    objects.shuffle();

    return objects.take(3).toList();
  }

  //
  // int get velocityRatio {
  //   final random = Random();
  //   return random.nextInt(2) + 1;
  // }

  // double get objectSize {
  //   switch (this) {
  //     case GarbageObject.paper:
  //       return 50;
  //     case GarbageObject.plasticBottle:
  //       return 80;
  //     case GarbageObject.fruit:
  //       return 100;
  //   }
  // }

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
    }
  }

  int get velocityRatio {
    switch (this) {
      case GarbageObject.paper:
        return 1;
      case GarbageObject.plasticBottle:
      case GarbageObject.glassBottle:
        return 2;
      case GarbageObject.fruit:
        return 3;
    }
  }
}
