import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

BarcodeScannerScreenConfiguration tinyBarcodesConfigSnippet() {
  // Create the default configuration object.
  var configuration = BarcodeScannerScreenConfiguration();

  // Enable locking the focus at the minimum possible distance.
  configuration.cameraConfiguration.minFocusDistanceLock = true;

  // Configure other parameters as needed.

  return configuration;
}
