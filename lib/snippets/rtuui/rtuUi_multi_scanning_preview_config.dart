import 'package:barcode_scanner/barcode_sdk.dart';

BarcodeScannerScreenConfiguration rtuUiMultipleScanningPreviewConfig() {
  // Create the default configuration object.
  var config = BarcodeScannerScreenConfiguration();

  // Initialize the use case for multiple scanning.
  var scanningMode = MultipleScanningMode();

  // Set the sheet mode for the barcodes preview.
  scanningMode.sheet.mode = SheetMode.COLLAPSED_SHEET;

  // Set the height for the collapsed sheet.
  scanningMode.sheet.collapsedVisibleHeight = CollapsedVisibleHeight.LARGE;

  // Configure the submit button on the sheet.
  scanningMode.sheetContent.submitButton.text = "Submit";
  scanningMode.sheetContent.submitButton.foreground.color =
      ScanbotColor("#000000");

  // Configure localization parameters.
  config.localization.barcodeInfoMappingErrorStateCancelButton = 'Custom Cancel title';
  config.localization.cameraPermissionCloseButton = 'Custom Close title';
  // Configure other strings as needed.

  // Configure other parameters, pertaining to multiple-scanning mode as needed.

  config.useCase = scanningMode;

  return config;
}
