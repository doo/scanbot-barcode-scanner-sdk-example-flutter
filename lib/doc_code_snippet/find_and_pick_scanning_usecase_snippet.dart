import 'package:barcode_scanner/scanbot_barcode_sdk_v2.dart';

void findAndPickModeUseCaseSnippet() {
  // Create the default configuration object.
  var configuration = BarcodeScannerConfiguration();

  // Initialize the use case for find and pick scanning.
  var scanningMode = FindAndPickScanningMode();

  // Set the sheet mode for the barcodes preview.
  scanningMode.sheet.mode = SheetMode.COLLAPSED_SHEET;

  // Enable/Disable the automatic selection.
  scanningMode.arOverlay.automaticSelectionEnabled = false;

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

  // Configure other parameters, pertaining to findAndPick-scanning mode as needed.
  // Set the expected barcodes.
  scanningMode.expectedBarcodes = [
    ExpectedBarcode(
        barcodeValue: "123456",
        title: "numeric barcode",
        image:
            "https://avatars.githubusercontent.com/u/1454920",
        count: 4),
    ExpectedBarcode(
        barcodeValue: "SCANBOT",
        title: "value barcode",
        image:
            "https://avatars.githubusercontent.com/u/1454920",
        count: 3)
  ];

  configuration.useCase = scanningMode;

  // Configure other parameters as needed.
}
