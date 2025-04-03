import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

BarcodeScannerScreenConfiguration rtuUiV2SingleScanningUseCase() {
  // Create the default configuration object.
  var configuration = BarcodeScannerScreenConfiguration();

  // Initialize the use case for single scanning.
  var scanningMode = SingleScanningMode();
  // Enable and configure the confirmation sheet.
  scanningMode.confirmationSheetEnabled = true;
  scanningMode.sheetColor = ScanbotColor("#FFFFFF");

  // Hide/unhide the barcode image.
  scanningMode.barcodeImageVisible = true;

  // Configure the barcode title of the confirmation sheet.
  scanningMode.barcodeTitle.visible = true;
  scanningMode.barcodeTitle.color = ScanbotColor("#000000");

  // Configure the barcode subtitle of the confirmation sheet.
  scanningMode.barcodeSubtitle.visible = true;
  scanningMode.barcodeSubtitle.color = ScanbotColor("#000000");

  // Configure the cancel button of the confirmation sheet.
  scanningMode.cancelButton.text = "Close";
  scanningMode.cancelButton.foreground.color = ScanbotColor("#C8193C");
  scanningMode.cancelButton.background.fillColor = ScanbotColor("#00000000");

  // Configure the submit button of the confirmation sheet.
  scanningMode.submitButton.text = "Submit";
  scanningMode.submitButton.foreground.color = ScanbotColor("#FFFFFF");
  scanningMode.submitButton.background.fillColor = ScanbotColor("#C8193C");

  // Configure other parameters, pertaining to single-scanning mode as needed.

  configuration.useCase = scanningMode;

  // Configure other parameters as needed.

  return configuration;
}
