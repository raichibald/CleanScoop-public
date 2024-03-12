import 'package:clean_scoop/clean_scoop_game/models/collected_object_data.dart';
import 'package:clean_scoop/clean_scoop_game/models/waste_object.dart';

enum WasteType { plastic, paper, glass, organic }

class ImpactData {
  final double energy;
  final double water;
  final double co2;

  const ImpactData({this.energy = 0, this.water = 0, this.co2 = 0});
}

class WasteImpactMapper {
  final Map<SpawnObject, CollectedObjectData> collectedAmounts;

  // Predefined impact data per kg of waste
  static const Map<SpawnObject, ImpactData> _impactPerKg = {
    SpawnObject.plasticBottle: ImpactData(energy: 5.6, co2: 1.6),
    SpawnObject.paper: ImpactData(energy: 4, water: 26, co2: 1.7),
    SpawnObject.glassBottle: ImpactData(energy: 1, co2: 0.3),
    SpawnObject.fruit: ImpactData(co2: 0.25),
  };

  WasteImpactMapper(this.collectedAmounts);

  factory WasteImpactMapper.empty() => WasteImpactMapper({});

  double get totalEnergySaved {
    return collectedAmounts.entries.fold(0, (total, entry) {
      var type = entry.key;
      var amount = entry.value.weight;
      var energy = _impactPerKg[type]!.energy;
      return total + (amount * energy);
    });
  }

  double get totalWaterSaved {
    return collectedAmounts.entries.fold(0, (total, entry) {
      var type = entry.key;
      var amount = entry.value.weight;
      var water = _impactPerKg[type]?.water ?? 0;
      return total + (amount * water);
    });
  }

  double get totalCO2Reduced {
    return collectedAmounts.entries.fold(0, (total, entry) {
      var type = entry.key;
      var amount = entry.value.weight;
      var co2 = _impactPerKg[type]!.co2;
      return total + (amount * co2);
    });
  }
}
