import 'package:flutter/rendering.dart';

enum StrokeStyle { solid, dottedBorder, dashedBorder }

enum TextAlignment { left, right, center }

enum FontFamily { commicShans, lillitaOne, nunnito }

enum FontSize { s, m, l, xL }

enum ShapeTypes { brush, rectangle, circle, line, textField }

extension ConvertToTextAlign on TextAlignment {
  TextAlign get textAlign {
    switch (this) {
      case TextAlignment.left:
      return TextAlign.left;
      case TextAlignment.right:
      return TextAlign.right;
      case TextAlignment.center:
      return TextAlign.center;
    }
  }
}

extension FontFamilyToString on FontFamily {
  String getString() {
    switch (this) {
      case FontFamily.commicShans:
        return 'CommicSans';
      case FontFamily.lillitaOne:
        return 'LilitaOne';
      case FontFamily.nunnito:
        return 'Nunito';
    }
  }
}

extension ConvertStringToEnum on String {
  FontFamily getFontFamily() {
    switch (this) {
      case 'Commic Sans':
        return FontFamily.commicShans;
      case 'LilitaOne':
        return FontFamily.lillitaOne;
      case 'Nunnito':
        return FontFamily.nunnito;
      default:
        return FontFamily.commicShans;
    }
  }
}

extension FontSizeToDouble on FontSize {
  double getSize() {
    switch (this) {
      case FontSize.s:
        return 12;
      case FontSize.m:
        return 14;
      case FontSize.l:
        return 16;
      case FontSize.xL:
        return 18;
    }
  }
}

extension ConvertDoubleToEnum on double {
  FontSize getFontSize() {
    switch (this) {
      case 12:
        return FontSize.s;
      case 14:
        return FontSize.m;
      case 16:
        return FontSize.l;
      case 16:
        return FontSize.xL;
      default:
        return FontSize.m;
    }
  }
}
