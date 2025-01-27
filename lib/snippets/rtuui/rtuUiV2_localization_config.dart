import 'package:barcode_scanner/scanbot_barcode_sdk_ui_v2.dart';

BarcodeScannerConfiguration configurationWithLocalizationSnippet() {
  // Create the default configuration object.
  var configuration = BarcodeScannerConfiguration();
  
  // Configure localization parameters.
  configuration.localization.barcodeInfoMappingErrorStateCancelButton =
      "Custom Cancel title";
  configuration.localization.cameraPermissionCloseButton = "Custom Close title";

  // Configure other strings as needed.

  // Configure other parameters as needed.

  return configuration;
}
