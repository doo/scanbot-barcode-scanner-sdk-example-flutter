import 'package:barcode_scanner/scanbot_barcode_sdk_ui_v2.dart';

BarcodeScannerConfiguration rtuUiV2MultipleScanningPreviewConfig(List<BarcodeFormat>? barcodeFormats) {
  // Create the default configuration object.
  var config = BarcodeScannerConfiguration();

  // Configure localization parameters.
  config.localization.barcodeInfoMappingErrorStateCancelButton = 'Custom Cancel title';
  config.localization.cameraPermissionCloseButton = 'Custom Close title';
  // Configure other strings as needed.

  // Configure other parameters as needed.
  // Set an array of accepted barcode types. If barcodeFormats is null, all barcode types are allowed.
  if (barcodeFormats != null)
    config.recognizerConfiguration.barcodeFormats = barcodeFormats;

  return config;
}
