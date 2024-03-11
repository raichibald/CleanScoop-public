import 'package:equatable/equatable.dart';

class CollectedObjectData extends Equatable {
  final int count;
  final double weight;

  const CollectedObjectData({
    required this.count,
    required this.weight,
  });

  CollectedObjectData copyWith({int? count, double? weight}) =>
      CollectedObjectData(
        count: count ?? this.count,
        weight: weight ?? this.weight,
      );

  @override
  List<Object?> get props => [
        count,
        weight,
      ];
}
