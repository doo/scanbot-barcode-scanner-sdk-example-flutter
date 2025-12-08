import 'package:barcode_scanner/barcode_sdk.dart';

BarcodeScannerScreenConfiguration configurationWithLocalizationSnippet() {
  // Create the default configuration object.
  var configuration = BarcodeScannerScreenConfiguration();

  // Configure localization parameters.
  configuration.localization.barcodeInfoMappingErrorStateCancelButton =
      "Custom Cancel title";
  configuration.localization.cameraPermissionCloseButton = "Custom Close title";

  // Configure other strings as needed.

  // Configure other parameters as needed.

  return configuration;
}
