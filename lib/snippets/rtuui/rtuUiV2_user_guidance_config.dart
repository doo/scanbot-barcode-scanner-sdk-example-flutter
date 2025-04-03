import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

BarcodeScannerScreenConfiguration rtuUiV2UserGuidanceConfigSnippet() {
  // Create the default configuration object.
  var configuration = BarcodeScannerScreenConfiguration();

  // Hide/unhide the user guidance.
  configuration.userGuidance.visible = true;

  // Configure the title.
  configuration.userGuidance.title.text = "Move the finder over a barcode";
  configuration.userGuidance.title.color = ScanbotColor("#FFFFFF");

  // Configure the background.
  configuration.userGuidance.background.fillColor = ScanbotColor("#0000007A");

  // Configure other parameters as needed.

  return configuration;
}
