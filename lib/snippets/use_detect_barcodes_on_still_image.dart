import 'package:barcode_scanner/barcode_sdk.dart';

Future<BarcodeScannerResult> detectBarcodeOnImage() async {
  /**
   * Select an image from the Image Library
   * Return early if no image is selected or there is an issue selecting an image
   **/
  final uriFilePath = "my-image-uri-path";

  /**
   * Detect the barcodes on the selected image
   */
  var result = await ScanbotSdk.barcode
      .scanFromImageFileUri(uriFilePath, BarcodeScannerConfiguration());

  return result;
}
