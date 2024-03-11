import 'package:clean_scoop/utils/extension/string_extension.dart';

extension DoubleExtension on double {
  String get formattedDouble => toStringAsFixed(2).withoutTrailingZeros;
}
