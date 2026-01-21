import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

Future<Result<BarcodeScannerResult>> scanBarcodesFromImageFileUri() async {
  /**
   * Select an image from the Image Library
   * Return early if no image is selected or there is an issue selecting an image
   **/
  final uriFilePath = "my-image-uri-path";

  /**
   * Scan barcodes from the selected image
   */
  var result = await ScanbotBarcodeSdk.barcode
      .scanFromImageFileUri(uriFilePath, BarcodeScannerConfiguration());

  return result;
}
