import 'package:barcode_scanner/scanbot_barcode_sdk_ui_v2.dart';

BarcodeScannerConfiguration rtuUiV2PreviewModeConfiguration() {
  // Create the default configuration object.
  var config = BarcodeScannerConfiguration();

  // Initialize the use case for multiple scanning.
  var scanningMode = MultipleScanningMode();

  // Set the sheet mode for the barcodes preview.
  scanningMode.sheet.mode = SheetMode.COLLAPSED_SHEET;

  // Set the height for the collapsed sheet.
  scanningMode.sheet.collapsedVisibleHeight = CollapsedVisibleHeight.LARGE;

  // Configure the submit button on the sheet.
  scanningMode.sheetContent.submitButton.text = 'Submit';
  scanningMode.sheetContent.submitButton.foreground.color = ScanbotColor('#000000');

  config.useCase = scanningMode;
  // Configure other parameters, pertaining to multiple-scanning mode as needed.

  // Configure other parameters as needed.

  return config;
}
