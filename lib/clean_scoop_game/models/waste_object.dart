import 'dart:math';

import 'package:clean_scoop/design_system/src/assets/assets.gen.dart';

enum WasteObject {
  paper(1),
  plasticBottle(2),
  glassBottle(3),
  fruit(4),
  cup(5),
  heart(6),
  poison(7);

  final int value;

  const WasteObject(this.value);

  factory WasteObject.fromRawValue(int rawValue) =>
      WasteObject.values.firstWhere(
        (item) => item.value == rawValue,
        orElse: () => WasteObject.paper,
      );

  static WasteObject get randomObject {
    final random = Random();
    final randomInt = random.nextInt(4) + 1;

    return WasteObject.fromRawValue(randomInt);
  }

  static List<WasteObject> get wasteObjects => [
        WasteObject.paper,
        WasteObject.plasticBottle,
        WasteObject.glassBottle,
        WasteObject.fruit,
      ];

  static List<WasteObject> get threeRandomObjects {
    var objects = wasteObjects.toList();
    objects.shuffle();

    return objects.take(3).toList();
  }

  String get icon {
    const icons = Assets.icons;

    switch (this) {
      case WasteObject.paper:
        return icons.icoPaperBall;
      case WasteObject.plasticBottle:
        return icons.icoPlasticBottle;
      case WasteObject.glassBottle:
        return icons.icoGlassBottle;
      case WasteObject.fruit:
        return icons.icoApple;
      case WasteObject.cup:
        return icons.icoCup;
      case WasteObject.heart:
        return icons.icoHeartLarge;
      case WasteObject.poison:
        return icons.icoMushroom;
    }
  }

  int get velocityRatio {
    switch (this) {
      case WasteObject.paper:
        return 1;
      case WasteObject.plasticBottle:
      case WasteObject.glassBottle:
      case WasteObject.poison:
        return 2;
      case WasteObject.fruit:
      case WasteObject.cup:
        return 3;
      case WasteObject.heart:
        return 4;
    }
  }

  double? get weightInKilograms {
    switch (this) {
      case WasteObject.paper:
        return 0.005;
      case WasteObject.plasticBottle:
        return 0.012;
      case WasteObject.glassBottle:
        return 0.2;
      case WasteObject.fruit:
        return 0.085;
      case WasteObject.cup:
        // TODO: Implement cup.
        return 3;
      case WasteObject.poison:
      case WasteObject.heart:
        return null;
    }
  }
}
