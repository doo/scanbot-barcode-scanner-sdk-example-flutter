import 'package:barcode_scanner/scanbot_barcode_sdk_ui_v2.dart';

BarcodeScannerConfiguration rtuUiV2ActionBarConfiguration(List<BarcodeFormat>? barcodeFormats) {
  // Create the default configuration object.
  var config = BarcodeScannerConfiguration();

  // Configure the action bar.

  // Hide/unhide the flash button.
  config.actionBar.flashButton.visible = true;

  // Configure the inactive state of the flash button.
  config.actionBar.flashButton.backgroundColor = ScanbotColor('#0000007A');
  config.actionBar.flashButton.foregroundColor = ScanbotColor('#FFFFFF');

  // Configure the active state of the flash button.
  config.actionBar.flashButton.activeBackgroundColor = ScanbotColor('#FFCE5C');
  config.actionBar.flashButton.activeForegroundColor = ScanbotColor('#000000');

  // Hide/unhide the zoom button.
  config.actionBar.zoomButton.visible = true;

  // Configure the inactive state of the zoom button.
  config.actionBar.zoomButton.backgroundColor = ScanbotColor('#0000007A');
  config.actionBar.zoomButton.foregroundColor = ScanbotColor('#FFFFFF');
  // Zoom button has no active state - it only switches between zoom levels (for configuring those please refer to camera configuring).

  // Hide/unhide the flip camera button.
  config.actionBar.flipCameraButton.visible = true;

  // Configure the inactive state of the flip camera button.
  config.actionBar.flipCameraButton.backgroundColor = ScanbotColor('#0000007A');
  config.actionBar.flipCameraButton.foregroundColor = ScanbotColor('#FFFFFF');
  // Flip camera button has no active state - it only switches between front and back camera.

  // Configure other parameters as needed.
  // Set an array of accepted barcode types. If barcodeFormats is null, all barcode types are allowed.
  if (barcodeFormats != null)
    config.recognizerConfiguration.barcodeFormats = barcodeFormats;

  return config;
}
