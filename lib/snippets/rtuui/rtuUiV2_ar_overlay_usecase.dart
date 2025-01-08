import 'package:barcode_scanner/scanbot_barcode_sdk_ui_v2.dart';

BarcodeScannerConfiguration rtuUiArOverlayUseCase(List<BarcodeFormat>? barcodeFormats) {
  // Create the default configuration object.
  var configuration = BarcodeScannerConfiguration();

  // Initialize the use case for multiple scanning.
  var scanningMode = MultipleScanningMode();

  scanningMode.mode = MultipleBarcodesScanningMode.UNIQUE;
  scanningMode.sheet.mode = SheetMode.COLLAPSED_SHEET;
  scanningMode.sheet.collapsedVisibleHeight = CollapsedVisibleHeight.SMALL;
  // Configure AR Overlay.
  scanningMode.arOverlay.visible = true;
  scanningMode.arOverlay.automaticSelectionEnabled = false;

  // Configure other parameters, pertaining to use case as needed.

  // Configure other parameters as needed.
  // Set an array of accepted barcode types. If barcodeFormats is null, all barcode types are allowed.
  if (barcodeFormats != null)
    configuration.recognizerConfiguration.barcodeFormats = barcodeFormats;

  return configuration;
}
