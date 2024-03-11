import 'package:clean_scoop/utils/regular_expression/regular_expression.dart';

extension StringExtension on String {
  String get withoutTrailingZeros => replaceAll(
        RegularExpression.omitTrailingZeros,
        '',
      );
}
