import 'package:barcode_scanner/scanbot_barcode_sdk_ui_v2.dart';

BarcodeScannerConfiguration rtuUiV2MultipleScanningUseCase(List<BarcodeFormat>? barcodeFormats) {
  // Create the default configuration object.
  var configuration = BarcodeScannerConfiguration();

  // Initialize the use case for multiple scanning.
  var scanningMode = MultipleScanningMode();

  // Set the counting mode.
  scanningMode.mode = MultipleBarcodesScanningMode.COUNTING;

  // Set the sheet mode for the barcodes preview.
  scanningMode.sheet.mode = SheetMode.COLLAPSED_SHEET;

  // Set the height for the collapsed sheet.
  scanningMode.sheet.collapsedVisibleHeight = CollapsedVisibleHeight.LARGE;

  // Enable manual count change.
  scanningMode.sheetContent.manualCountChangeEnabled = true;

  // Set the delay before same barcode counting repeat.
  scanningMode.countingRepeatDelay = 1000;

  // Configure the submit button.
  scanningMode.sheetContent.submitButton.text = "Submit";
  scanningMode.sheetContent.submitButton.foreground.color =
      ScanbotColor("#000000");

  // Configure other parameters, pertaining to multiple-scanning mode as needed.

  configuration.useCase = scanningMode;

  // Configure other parameters as needed.
  // Set an array of accepted barcode types. If barcodeFormats is null, all barcode types are allowed.
  if (barcodeFormats != null)
    configuration.recognizerConfiguration.barcodeFormats = barcodeFormats;

  return configuration;
}
