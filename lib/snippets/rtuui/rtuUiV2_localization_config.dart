import 'package:barcode_scanner/scanbot_barcode_sdk_ui_v2.dart';

BarcodeScannerConfiguration configurationWithLocalizationSnippet(List<BarcodeFormat>? barcodeFormats) {
  // Create the default configuration object.
  var configuration = BarcodeScannerConfiguration();
  
  // Configure localization parameters.
  configuration.localization.barcodeInfoMappingErrorStateCancelButton =
      "Custom Cancel title";
  configuration.localization.cameraPermissionCloseButton = "Custom Close title";

  // Configure other strings as needed.

  // Configure other parameters as needed.
  // Set an array of accepted barcode types. If barcodeFormats is null, all barcode types are allowed.
  if (barcodeFormats != null)
    configuration.recognizerConfiguration.barcodeFormats = barcodeFormats;

  return configuration;
}
