import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

Future<BarcodeScannerResult> detectBarcodeOnImage() async {
  /**
   * Select an image from the Image Library
   * Return early if no image is selected or there is an issue selecting an image
   **/
  final uriFilePath = Uri.file("my-image-uri-path");

  /**
   * Detect the barcodes on the selected image
   */
  var result = await ScanbotBarcodeSdk.detectBarcodesOnImage(uriFilePath, BarcodeScannerConfiguration());

  return result;
}