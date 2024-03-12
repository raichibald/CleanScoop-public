import 'package:clean_scoop/clean_scoop_game/models/collected_object_data.dart';
import 'package:clean_scoop/clean_scoop_game/models/environmental_impact_data.dart';
import 'package:clean_scoop/clean_scoop_game/models/waste_object.dart';

class WasteImpactMapper {
  final Map<SpawnObject, CollectedObjectData> collectedWaste;

  static const Map<SpawnObject, EnvironmentalImpactData> _impactPerKg = {
    SpawnObject.plasticBottle: EnvironmentalImpactData(energy: 5.6, co2: 1.6),
    SpawnObject.paper: EnvironmentalImpactData(energy: 4, water: 26, co2: 1.7),
    SpawnObject.glassBottle: EnvironmentalImpactData(energy: 1, co2: 0.3),
    SpawnObject.fruit: EnvironmentalImpactData(co2: 0.25),
  };

  const WasteImpactMapper(this.collectedWaste);

  double get totalEnergySaved => _getImpactTotals((data) => data.energy);

  double get totalWaterSaved => _getImpactTotals((data) => data.water);

  double get totalCO2Reduced => _getImpactTotals((data) => data.co2);

  double _getImpactTotals(
    double Function(EnvironmentalImpactData) dataSelector,
  ) =>
      collectedWaste.entries.fold(0, (total, entry) {
        final type = entry.key;
        final amount = entry.value.weight;
        final impact = _impactPerKg[type];
        final propertyValue = impact != null ? dataSelector(impact) : 0;

        return total + (amount * propertyValue);
      });
}
