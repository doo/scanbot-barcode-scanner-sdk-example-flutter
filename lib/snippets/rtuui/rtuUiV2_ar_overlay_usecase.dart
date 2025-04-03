import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

BarcodeScannerScreenConfiguration rtuUiArOverlayUseCase() {
  // Create the default configuration object.
  var configuration = BarcodeScannerScreenConfiguration();

  // Initialize the use case for multiple scanning.
  var scanningMode = MultipleScanningMode();

  scanningMode.mode = MultipleBarcodesScanningMode.UNIQUE;
  scanningMode.sheet.mode = SheetMode.COLLAPSED_SHEET;
  scanningMode.sheet.collapsedVisibleHeight = CollapsedVisibleHeight.SMALL;
  // Configure AR Overlay.
  scanningMode.arOverlay.visible = true;
  scanningMode.arOverlay.automaticSelectionEnabled = false;

  configuration.useCase = scanningMode;

  // Configure other parameters as needed.

  return configuration;
}
