import 'package:barcode_scanner/scanbot_barcode_sdk_v2.dart';
import 'package:barcode_scanner/sdk_utils.dart';

void userGuidanceConfigSnippet() {
  // Create the default configuration object.
  var configuration = BarcodeScannerConfiguration();

  // Hide/unhide the user guidance.
  configuration.userGuidance.visible = true;

  // Configure the title.
  configuration.userGuidance.title.text = "Move the finder over a barcode";
  configuration.userGuidance.title.color = ScanbotColor("#FFFFFF");

  // Configure the background.
  configuration.userGuidance.background.fillColor = ScanbotColor("#7A000000");

  // Configure other parameters as needed.
}
