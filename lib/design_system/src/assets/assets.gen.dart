/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/ico_apple.svg
  String get icoApple => 'assets/icons/ico_apple.svg';

  /// File path: assets/icons/ico_background.svg
  String get icoBackground => 'assets/icons/ico_background.svg';

  /// File path: assets/icons/ico_glass_bottle.svg
  String get icoGlassBottle => 'assets/icons/ico_glass_bottle.svg';

  /// File path: assets/icons/ico_heart.svg
  String get icoHeart => 'assets/icons/ico_heart.svg';

  /// File path: assets/icons/ico_logo.svg
  String get icoLogo => 'assets/icons/ico_logo.svg';

  /// File path: assets/icons/ico_mushroom.svg
  String get icoMushroom => 'assets/icons/ico_mushroom.svg';

  /// File path: assets/icons/ico_paper_ball.svg
  String get icoPaperBall => 'assets/icons/ico_paper_ball.svg';

  /// File path: assets/icons/ico_pause.svg
  String get icoPause => 'assets/icons/ico_pause.svg';

  /// File path: assets/icons/ico_plastic_bottle.svg
  String get icoPlasticBottle => 'assets/icons/ico_plastic_bottle.svg';

  /// File path: assets/icons/ico_play.svg
  String get icoPlay => 'assets/icons/ico_play.svg';

  /// List of all assets
  List<String> get values => [
        icoApple,
        icoBackground,
        icoGlassBottle,
        icoHeart,
        icoLogo,
        icoMushroom,
        icoPaperBall,
        icoPause,
        icoPlasticBottle,
        icoPlay
      ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/img_background_bars.png
  AssetGenImage get imgBackgroundBars =>
      const AssetGenImage('assets/images/img_background_bars.png');

  /// List of all assets
  List<AssetGenImage> get values => [imgBackgroundBars];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
