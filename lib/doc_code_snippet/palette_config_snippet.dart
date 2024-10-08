import 'package:barcode_scanner/scanbot_barcode_sdk_v2.dart';

void paletteConfigSnippet() {
  // Create the default configuration object.
  var configuration = BarcodeScannerConfiguration();

  var palette = Palette();

  // Simply alter one color and keep the other default.
  palette.sbColorPrimary = ScanbotColor("#c86e19");

  // ... or set an entirely new palette.
  palette.sbColorPrimary = ScanbotColor("#C8193C");
  palette.sbColorPrimaryDisabled = ScanbotColor("#F5F5F5");
  palette.sbColorNegative = ScanbotColor("#FF3737");
  palette.sbColorPositive = ScanbotColor("#4EFFB4");
  palette.sbColorWarning = ScanbotColor("#FFCE5C");
  palette.sbColorSecondary = ScanbotColor("#FFEDEE");
  palette.sbColorSecondaryDisabled = ScanbotColor("#F5F5F5");
  palette.sbColorOnPrimary = ScanbotColor("#FFFFFF");
  palette.sbColorOnSecondary = ScanbotColor("#C8193C");
  palette.sbColorSurface = ScanbotColor("#FFFFFF");
  palette.sbColorOutline = ScanbotColor("#EFEFEF");
  palette.sbColorOnSurfaceVariant = ScanbotColor("#707070");
  palette.sbColorOnSurface = ScanbotColor("#000000");
  palette.sbColorSurfaceLow = ScanbotColor("#00000026");
  palette.sbColorSurfaceHigh = ScanbotColor("#0000007A");
  palette.sbColorModalOverlay = ScanbotColor("#000000A3");

  configuration.palette = palette;
}
