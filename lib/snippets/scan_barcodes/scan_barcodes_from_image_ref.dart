import 'package:barcode_scanner/scanbot_barcode_sdk.dart';

Future<Result<BarcodeScannerResult>> scanBarcodesFromImageRef() async {
  /**
   * Select an image from the Image Library
   * Return early if no image is selected or there is an issue selecting an image
   **/
  final path = "my-image-uri-path";
  return await autorelease(() async {
    final imageRef = ImageRef.fromPath(path);

    /**
     * Scan barcodes from the selected image
     */
    var result = await ScanbotBarcodeSdk.barcode
        .scanFromImageRef(imageRef, BarcodeScannerConfiguration());

    return result;
  });
}
