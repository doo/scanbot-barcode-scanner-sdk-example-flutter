import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

Future<Result<BarcodeScannerResult>> scanBarcodeFromPdf() async {
  /**
   * Select a PDF from the file picker
   **/
  final pdfFileUri = "my-pdf-uri-path";

  /**
   * Detect the barcodes on the selected PDF
   */
  var result = await ScanbotBarcodeSdk.barcode
      .scanFromPdf(pdfFileUri, BarcodeScannerConfiguration());

  return result;
}
