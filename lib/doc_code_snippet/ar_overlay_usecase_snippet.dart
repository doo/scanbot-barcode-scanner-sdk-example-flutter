import 'package:barcode_scanner/scanbot_barcode_sdk_v2.dart';

void arOverlayUseCaseSnippet() {
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

  // Set an array of accepted barcode types.
  // configuration.recognizerConfiguration.barcodeFormats = [
  //   scanbotV2.BarcodeFormat.AZTEC,
  //   scanbotV2.BarcodeFormat.PDF_417,
  //   scanbotV2.BarcodeFormat.QR_CODE,
  //   scanbotV2.BarcodeFormat.MICRO_QR_CODE,
  //   scanbotV2.BarcodeFormat.MICRO_PDF_417,
  //   scanbotV2.BarcodeFormat.ROYAL_MAIL,
  ///  .....
  // ];

  // Configure other parameters as needed.
}
