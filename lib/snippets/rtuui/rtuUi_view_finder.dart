import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

BarcodeScannerScreenConfiguration viewFinderConfigSnippet() {
  // Create the default configuration object.
  var configuration = BarcodeScannerScreenConfiguration();

  // Show the view finder
  configuration.viewFinder.visible = true;

  // Set the aspect ratio of the view finder
  configuration.viewFinder.aspectRatio =
      new AspectRatio(width: 16.0, height: 9.0);

  configuration.viewFinder.style = new FinderCorneredStyle(
    // Set the color of the view finder corners
    strokeColor: ScanbotColor('#ff0005'),
    // Set the width of the view finder corners
    strokeWidth: 10.0,
  );

  // Configure other parameters as needed.

  return configuration;
}
