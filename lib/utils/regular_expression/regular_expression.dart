class RegularExpression {
  static final omitTrailingZeros = RegExp(r"([.]*0+)(?!.*\d)");
}
